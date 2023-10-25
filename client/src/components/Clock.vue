<script setup>
  import axios from "axios";
  import { store } from "@/store";

  import { Button } from "@/components/ui/button";
  import { ref } from "vue";

  console.log(store.user);

  const working = ref(false);
  let dateStart = ref(new Date());
  let dateEnd = ref(new Date());
  let userId = null;

  async function toggleWorkStatus() {
    working.value = !working.value;
    if (working.value) {
      dateStart.value = new Date();
      try {
        let response = await axios.post("/api/clocks", {
          clock: {
            user_id: 1,
            user: {
              username: "mxttmg",
              email: "matteo.murgolo@epitech.eu",
            },
            time: dateStart.value.toISOString(),
            status: true,
          },
        });
        dateStart.value = response.data.time;
        userId = response.data.id;
      } catch (error) {
        console.log(error);
      }
    } else {
      try {
        dateEnd.value = new Date();
        let response = await axios.get("/api/clocks", {
          params: { userId: 1 },
        });
        let clockData = response.data;

        if (clockData.status) {
          let clockInfo = {
            id: clockData.id,
            time: clockData.time,
            status: clockData.status,
            user_id: clockData.user_id,
          };
          // TODO Créer un working time

          await axios.post("/api/clocks", {
            clock: {
              user_id: 1,
              user: {
                username: "mxttmg",
                email: "matteo.murgolo@epitech.eu",
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
  <button
    @click="toggleWorkStatus"
    :class="{
      'bg-green-500 hover:bg-green-700': !working,
      'bg-red-500 hover:bg-red-700': working,
    }"
    class="text-white font-bold py-2 px-4 rounded transition duration-300">
    {{ working ? "Terminer le travail" : "Commencer le travail" }}
  </button>
</template>
