<script setup>
  import axios from "axios";
  import { store } from "@/store";

  import { Button } from "@/components/ui/button";
  import { ref } from "vue";

  const working = ref(false);
  const elapsedTime = ref("");
  let interval;
  let dateStart = ref(new Date());
  let dateEnd = ref(new Date());
  let userId = store.user.id;
  let userEmail = store.user.email;
  let userName = store.user.username;
  let clockId = ref(0);

  function calculateElapsedTime() {
    if (!dateStart.value) {
      console.log("dateStart.value n'est pas défini");
      return "00:00:00";
    }

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
    working.value = !working.value;
    if (working.value) {
      dateStart.value = new Date();
      calculateElapsedTime();

      interval = setInterval(calculateElapsedTime, 1000);
      try {
        let response = await axios.post("http://localhost:4000/api/clocks", {
          clock: {
            user_id: userId,
            user: {
              username: userName.value,
              email: userEmail.value,
            },
            time: dateStart.value.toISOString(),
            status: true,
          },
        });
        dateStart.value = response.data.data.time;
        clockId.value = response.data.data.id;
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
          "http://localhost:4000/api/clocks/" + clockId.value
        );
        let clockData = response.data;

        if (clockData.status) {
          let clockInfo = {
            id: clockData.id,
            time: clockData.time,
            status: clockData.status,
            user_id: clockData.user_id,
          };

          await axios.post("http://localhost:4000/api/workingtimes/", {
            working_time: {
              user_id: userId,
              start: dateStart.value,
              end: dateEnd.value,
            },
          });

          await axios.post("http://localhost:4000/api/clocks", {
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
        }
      } catch (error) {
        console.log(error);
      }
    }
  }
</script>

<template>
  <div
    v-if="!store.user.id"
    class="flex items-center mt-10 justify-center">
    <div class="text-center p-6 bg-white rounded-lg shadow-lg">
      <h2 class="text-2xl font-bold text-red-600 mb-3">Connectez-vous</h2>
      <p class="text-gray-700">
        Merci de vous connecter pour enregistrer votre temps de travail
      </p>
    </div>
  </div>

  <div
    v-if="store.user.id"
    class="flex justify-center mt-4">
    <button
      @click="toggleWorkStatus"
      :class="{
        'bg-green-500 hover:bg-green-700': !working,
        'bg-red-500 hover:bg-red-700': working,
      }"
      class="text-white font-bold py-2 px-4 rounded transition duration-300">
      {{ working ? "Terminer le travail" : "Commencer le travail" }}
    </button>
    <div
      v-if="store.user.id && working"
      class="flex flex-col mt-4 items-center">
      <p class="text-gray-700 mt-2">
        Début du travail : {{ new Date(dateStart).toLocaleTimeString() }}
      </p>
      <p class="text-gray-700 mt-2">Temps écoulé : {{ elapsedTime }}</p>
    </div>
  </div>
</template>
