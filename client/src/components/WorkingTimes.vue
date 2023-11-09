<script setup>
import {ref} from "vue";
import {store} from "@/store.ts";
import axios from "axios";
import moment from "moment";

let workingtimes = ref([]);
let isLoaded = ref(false);

getWorkingTimes();

async function getWorkingTimes() {
  axios
      .get(
          "https://api-time-manager.thomasbasquin.fr/api/workingtimes/" +
          store.user.id
          , {
            withCredentials: true,
            headers: {
              'authorization': 'Bearer ' + localStorage.getItem('xsrf_token'),
            },
          })
      .then(function (response) {
        // Gérer la réponse ici
        const data = response.data;
        workingtimes = response.data;
        console.log(response.data);
        console.log(workingtimes);
        calculateWorkHours(data);
        isLoaded.value = true;
      })
      .catch(function (error) {
        // Gérer les erreurs ici
        console.error(error);
      });
}

function calculateWorkHours(data) {
  // Filtrer les données pour ne conserver que celles de la semaine en cours
  const today = new Date();
  const firstDayOfWeek = new Date(today);
  firstDayOfWeek.setDate(today.getDate() - today.getDay()); // Réglage pour obtenir le lundi de la semaine en cours

  data = data.filter((item) => {
    const startDate = new Date(item.start);
    return startDate >= firstDayOfWeek && startDate <= today;
  });

  // Convertir les dates de début et de fin en objets Date
  data.forEach((item) => {
    item.start = new Date(item.start);
    item.end = new Date(item.end);
  });

  // Calculer les heures de travail pour chaque entrée
  data.forEach((item) => {
    const timeDiff = item.end - item.start; // Différence en millisecondes
    const workHours = timeDiff / (1000 * 60 * 60); // Convertir en heures
    // Arrondir à 2 décimales
    item.workHours = Math.round(workHours * 100) / 100;
  });

  // Calculer les heures de travail totales pour la semaine
  const totalWorkHours = data.reduce(
      (total, item) => total + item.workHours,
      0
  );

  // Calculer le temps travaillé par rapport aux 35 heures
  const hoursPerWeek = 35;
  const workPercentage = (totalWorkHours / (hoursPerWeek * 7)) * 100;

  workingtimes = data;
}

const Username = ref("Username");
const UserID = ref("UserID");
const Clockin = ref("Clock in");
const Clockout = ref("Clock out");
const WorkTime = ref("Work Time");

const dateFormatee = (dateOrigine) => {
  return moment(dateOrigine).format("D MMMM YYYY, HH:mm:ss");
};
</script>

<template>
  <li
      v-if="isLoaded === true"
      v-for="workingtime in workingtimes">
    {{ Username }} - {{ workingtime.user.username }} - {{ UserID }} -
    {{ workingtime.user.id }} - {{ Clockin }} -
    {{ dateFormatee(workingtime.start) }} - {{ Clockout }} -
    {{ dateFormatee(workingtime.end) }} - {{ WorkTime }} -
    {{ workingtime.workHours }}
  </li>
</template>
