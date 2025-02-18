from flask import Flask, render_template, request

app = Flask(__name__)

# Fonction pour estimer la consommation électrique
def estimer_consommation(nb_occupants):
    if nb_occupants < 1:
        return 0  # Retourner 0 pour les valeurs invalides
    if nb_occupants == 1:
        return (200 + 300) / 2  # Moyenne mensuelle pour une personne seule
    elif nb_occupants == 4:
        return (1400 + 1800) / 2  # Moyenne mensuelle pour une famille de 4 personnes
    else:
        consommation_par_personne = 350  # Hypothèse mensuelle par personne
        return consommation_par_personne * nb_occupants

# Classe pour recommander une installation photovoltaïque
class PVRecommender:
    def __init__(self):
        # Hypothèses techniques pour différents types de panneaux
        self.panneaux = [
            {"puissance": 375, "surface": 1.9, "prix": 320},
            {"puissance": 425, "surface": 1.9, "prix": 340}
        ]
        # Données de production minimale selon la taille des centrales
        self.centrales = [
            {"taille": 15, "puissance": 3, "production_min": (4500, 5500)},
            {"taille": 30, "puissance": 6, "production_min": (9000, 11000)},
            {"taille": 45, "puissance": 9, "production_min": (13500, 16500)},
            {"taille": 60, "puissance": 12, "production_min": (18000, 22000)},
            {"taille": 75, "puissance": 15, "production_min": (22500, 27500)},
            {"taille": 90, "puissance": 18, "production_min": (27000, 33000)}
        ]

    def recommend_pv(self, surface, consommation_mensuelle, budget):
        if not (3 <= surface <= 90):
            return f"⚠️ La surface doit être comprise entre 3 et 90 m². Vous avez entré {surface} m²."

        besoin_puissance = consommation_mensuelle * 12 / 1.2  # kWh/an en Wc
        recommendations = []

        for panneau in self.panneaux:
            nombre_panneaux = min(int(surface // panneau["surface"]), int(budget // panneau["prix"]))
            if nombre_panneaux > 0:
                surface_requise = nombre_panneaux * panneau["surface"]
                cout_total = nombre_panneaux * panneau["prix"]
                production_annuelle = nombre_panneaux * panneau["puissance"] / 1000 * 12  # kWh/an
                production_mensuelle = production_annuelle / 12  # kWh/mois

                recommendations.append(
                    f"- **{nombre_panneaux} panneaux de {panneau['puissance']} Wc** ({surface_requise:.1f} m² requis, "
                    f"{production_mensuelle:.1f} kWh/mois, {production_annuelle:.1f} kWh/an)\n"
                    f"  💰 **Coût estimé :** {cout_total:,.2f} €"
                )

        for centrale in self.centrales:
            production_min = centrale["production_min"]
            recommendations.append(
                f"- **Centrale de {centrale['puissance']} kWc ({centrale['taille']} m²)** : "
                f"Production annuelle entre {production_min[0]} et {production_min[1]} kWh/an"
            )

        if not recommendations:
            return "❌ Aucun système photovoltaïque ne correspond aux critères de surface et de budget."

        return "✅ **Installation possible sur {0:.1f} m²**\n\n".format(surface) + "\n\n".join(recommendations)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            nb_occupants = int(request.form['nb_occupants'])
            if nb_occupants < 1:
                return render_template('index.html', error="⚠️ Le nombre d'occupants doit être supérieur à 0.")
            surface = float(request.form['surface'])
            if surface <= 0:
                return render_template('index.html', error="⚠️ Veuillez entrer une surface positive.")
            budget = float(request.form['budget'])
            if budget <= 0:
                return render_template('index.html', error="⚠️ Veuillez entrer un budget positif.")

            consommation_moyenne = estimer_consommation(nb_occupants)
            recommender = PVRecommender()
            recommendation = recommender.recommend_pv(surface, consommation_moyenne, budget)

            return render_template('result.html', recommendation=recommendation)
        except ValueError:
            return render_template('index.html', error="⚠️ Veuillez entrer des valeurs valides.")
        except Exception as e:
            return render_template('index.html', error=f"⚠️ Une erreur inattendue s'est produite : {e}")

    return render_template('index.html')

if __name__ == "__main__":
    app.run(debug=True, port=5002)
