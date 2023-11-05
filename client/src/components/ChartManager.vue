<template>
  <div>
    <canvas ref="myChart"></canvas>
  </div>
</template>

<script>
import {Chart} from 'chart.js/auto';
import axios from 'axios';
import {store} from "@/store";

export default {
  data() {
    return {
      chartData: {},
    };
  },
  mounted() {
    this.getDataFromAPI();
  },
  methods: {
    async getDataFromAPI() {
      try {
        const response = await axios.get('http://157.230.19.19:4000/api/workingtimes/' + store.user.id);
        console.log(response.data);
        this.chartData = response.data; // Assurez-vous que votre API renvoie les données dans un format adapté au graphique (voir la documentation de Chart.js)
        this.calculateWorkHours();
      } catch (error) {
        console.error('Erreur lors de la récupération des données depuis l\'API', error);
      }
    },
    calculateWorkHours() {
      // Filtrer les données pour ne conserver que celles de la semaine en cours
      const today = new Date();
      const firstDayOfWeek = new Date(today);
      firstDayOfWeek.setDate(today.getDate() - today.getDay()); // Réglage pour obtenir le lundi de la semaine en cours

      this.chartData = this.chartData.filter(item => {
        const startDate = new Date(item.start);
        return startDate >= firstDayOfWeek && startDate <= today;
      });

      // Convertir les dates de début et de fin en objets Date
      this.chartData.forEach(item => {
        item.start = new Date(item.start);
        item.end = new Date(item.end);
      });

      // Calculer les heures de travail pour chaque entrée
      this.chartData.forEach(item => {
        const timeDiff = item.end - item.start; // Différence en millisecondes
        const workHours = timeDiff / (1000 * 60 * 60); // Convertir en heures
        item.workHours = workHours;
      });

      // Calculer les heures de travail totales pour la semaine
      const totalWorkHours = this.chartData.reduce((total, item) => total + item.workHours, 0);

      // Calculer le temps travaillé par rapport aux 35 heures
      const hoursPerWeek = 35;
      const workPercentage = (totalWorkHours / (hoursPerWeek * 7)) * 100;

      this.createChart(workPercentage);
    },
    createChart(workPercentage) {
      const ctx = this.$refs.myChart.getContext('2d');
      new Chart(ctx, {
        type: 'pie', // Utiliser un graphique en forme de donut pour afficher le pourcentage de travail par rapport aux 35 heures
        data: {
          labels: ['Temps travaillé', 'Temps restant'],
          datasets: [{
            data: [workPercentage, 100 - workPercentage],
            backgroundColor: ['rgba(75, 192, 192, 0.5)', 'rgba(0, 0, 0, 0.2)'],
          }],
        },
        options: {
          cutoutPercentage: 70, // Contrôle l'épaisseur de l'anneau (70% par exemple)
        },
      });
    },
  },
};
</script>