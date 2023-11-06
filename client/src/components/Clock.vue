<script setup>
import axios from "axios";
import {store} from "@/store";
import {Button} from "@/components/ui/button";
import {ref} from "vue";
import moment from 'moment'

let clock = ref([]);
let dateStart = ref(new Date());
let clockId = ref(0);

const dateFormat = (dateOrigine) => {
  return moment(dateOrigine).format('D MMMM YYYY, HH:mm:ss');
}

async function getWorkingTimes() {
  try {
    // Effectuer la requête GET pour récupérer les temps de travail
    const request = "http://localhost:4000/api/workingtimes/" + store.user.id
    const response = await axios.get(request, {})

    // Traiter la réponse de l'API
    store.workingtimes = response.data
    console.log('working time récupéré :', store.workingtimes)
    store.workingtimes = store.workingtimes.reverse();
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'utilisateur :', error)
  }
}

async function getClock() {
  try {
    // Effectuer la requête GET pour récupérer la clock
    const request = "http://157.230.19.191:4000/api/clocks/"
    const response = await axios.get(request, {})

    // Parse the JSON response to find the clock of the user
    for (let i = 0; i < response.data.length; i++) {
      if (response.data[i].user_id === store.user.id) {
        store.clock = response.data[i]
      }
    }

    // Traiter la réponse de l'API
    dateStart.value = store.clock.time;
    console.log("la clock est: " + dateStart.value)
    clockId.value = store.clock.id;
    store.working = store.clock.status === true;
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'utilisateur :', error)
  }
}

getClock()

const elapsedTime = ref("");
let dateEnd = ref(new Date());
let interval;
let userId = store.user.id;
let userEmail = store.user.email;
let userName = store.user.username;

function calculateElapsedTime() {
  const now = new Date();
  const elapsed = now - new Date(dateStart.value);

  if (isNaN(elapsed)) {
    console.log("Le temps écoulé est NaN");
    return "00:00:00";
  }

  const totalSeconds = Math.floor(elapsed / 1000);
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = Math.floor((totalSeconds % 3600) % 60);

  let hoursString = hours < 10 ? "0" + hours : hours;
  let minutesString = minutes < 10 ? "0" + minutes : minutes;
  let secondsString = seconds < 10 ? "0" + seconds : seconds;

  console.log(hoursString, minutesString, secondsString);

  elapsedTime.value = hoursString + ":" + minutesString + ":" + secondsString;
}

async function toggleWorkStatus() {
  store.working = !store.working;
  if (store.working) {
    dateStart.value = new Date();
    calculateElapsedTime();

    interval = setInterval(calculateElapsedTime, 1000);
    try {
      let response = await axios.put("http://157.230.19.191:4000/api/clocks/" + store.clock.id, {
        clock: {
          user_id: userId,
          user: {
            username: userName,
            email: userEmail,
          },
          time: dateStart.value.toISOString(),
          status: true,
        },
      });
      dateStart.value = response.data.time;
      clockId.value = response.data.id;
      await getClock();
      await getWorkingTimes();
    } catch (error) {
      console.log(error);
    }
  } else {
    if (interval) {
      clearInterval(interval);
    }
    try {
      dateEnd.value = new Date();
      let response = await axios.get(
          "http://157.230.19.191:4000/api/clocks/" + clockId.value
      );
      let clockData = response.data;

      if (clockData.status) {
        let clockInfo = {
          id: clockData.id,
          time: clockData.time,
          status: clockData.status,
          user_id: clockData.user_id,
        };

        await axios.post("http://157.230.19.191:4000/api/workingtimes/", {
          working_time: {
            user_id: userId,
            start: dateStart.value,
            end: dateEnd.value,
          },
        });

        await axios.put("http://157.230.19.191:4000/api/clocks/" + store.clock.id, {
          clock: {
            user_id: userId,
            user: {
              username: userName.value,
              email: userEmail.value,
            },
            time: dateEnd.value.toISOString(),
            status: false,
          },
        });
        await getClock();
        await getWorkingTimes();
      }
    } catch (error) {
      console.log(error);
    }
  }
}
</script>

<template>
  <div v-if="store.user.id" class="flex flex-col items-center mt-4">
    <button @click="toggleWorkStatus"
            :class="{
        'bg-green-500 hover:bg-green-700': !store.working,
        'bg-red-500 hover:bg-red-700': store.working,
      }"
            class="text-white font-bold py-2 px-4 rounded transition duration-300">
      {{ store.working ? "Terminer le travail" : "Commencer le travail" }}
    </button>
    <div v-if="store.user.id && store.working" class="flex flex-col mt-4 items-center">
      <p class="text-gray-700 mt-2">
        Début du travail : {{ new Date(dateStart).toLocaleTimeString() }}
      </p>
      <p class="text-gray-700 mt-2">
        Temps écoulé : {{ elapsedTime }}
      </p>
    </div>
  </div>
</template>