<script setup>
// Import Toaster from vue-sonner
import { toast, Toaster } from 'vue-sonner'

// Import store
import { store } from "@/store.ts";

// Import utils
import axios from "axios";
import moment from "moment";
import { ref, nextTick } from "vue";

// Import UI components
import Input from "@/components/ui/input/Input.vue";
import Card from "@/components/ui/card/Card.vue";
import CardHeader from "@/components/ui/card/CardHeader.vue";
import CardTitle from "@/components/ui/card/CardTitle.vue";
import Button from "@/components/ui/button/Button.vue";
import CardContent from "@/components/ui/card/CardContent.vue";
import CardFooter from "@/components/ui/card/CardFooter.vue";
import CardDescription from "@/components/ui/card/CardDescription.vue";


// Initializations variables
let workingtimes = ref([]);
let working_times = ref([]);
let isLoaded = ref(false);
let email = ref("");
let user = ref({});
let team_name = ref("");
let email_manager = ref("");
let manager = ref({});
let status = ref(0);
let search_bar = ref("");
let isDataFetch = ref(0);
let renderComponent = ref(true);

// Loading screen for 500ms
setTimeout(() => {
  isLoaded.value = true;
}, 500);

const forceRender = async () => {
  // Here, we'll remove MyComponent
  renderComponent.value = false;

  // Then, wait for the change to get flushed to the DOM
  await nextTick();

  // Add MyComponent back in
  renderComponent.value = true;
};

async function getWorkingTimes(id) {
  axios
    .get(
      "https://api-time-manager.thomasbasquin.fr/api/workingtimes/" +
      id
      , {
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
      isDataFetch.value = 0;
      isDataFetch.value = 1;
      forceRender();
      console.log(workingtimes);
    })
    .catch(function (error) {
      console.error(error);
    });
}

function calculateWorkHours(data) {
  // Filter data to get only the current week
  const today = new Date();
  const firstDayOfWeek = new Date(today);
  firstDayOfWeek.setDate(today.getDate() - today.getDay()); // Set to first day of the week

  data = data.filter((item) => {
    const startDate = new Date(item.start);
    return startDate >= firstDayOfWeek && startDate <= today;
  });

  // Convert dates to Date objects
  data.forEach((item) => {
    item.start = new Date(item.start);
    item.end = new Date(item.end);
  });

  // Calculate work hours for each day
  data.forEach((item) => {
    const timeDiff = item.end - item.start;
    const workHours = timeDiff / (1000 * 60 * 60); // Convert milliseconds to hours
    item.workHours = Math.round(workHours * 100) / 100;
  });

  // Calculate total work hours
  const totalWorkHours = data.reduce(
    (total, item) => total + item.workHours,
    0
  );

  // Calculate work percentage
  const hoursPerWeek = 35;
  const workPercentage = (totalWorkHours / (hoursPerWeek * 7)) * 100;
  working_times = data;
  isDataFetch.value = 1;
}

const dateFormat = (dateOrigine) => {
  return moment(dateOrigine).format("D MMMM YYYY, HH:mm:ss");
};

async function promoteUser(role) {
  try {
    console.log(email)
    const userSearch = await axios.get(
      "https://api-time-manager.thomasbasquin.fr/api/users/",
      {
        params: {
          email: email.value,
        },
      }
    );

    // Traiter la réponse de l'API
    const userData = userSearch.data;
    console.log("Utilisateur récupéré :", userData);
    for (let i = 0; i < userData.data.length; i++) {
      if (userData.data[i].email === email.value) {
        user.value = userData.data[i];
      }
    }
    console.log(user.value)
    // Effectuer la requête PUT pour promouvoir l'utilisateur
    const response = await axios.put(
      "https://api-time-manager.thomasbasquin.fr/api/users/" + user.value.id,
      {
        user: {
          role: role,
        },
      },
      {
        headers: {
          authorization: "Bearer " + localStorage.getItem("xsrf_token"),
        },
      }
    );
    // Traiter la réponse de l'API
    const userPromote = response.data;
    console.log("Utilisateur promu :", userPromote);
    switch (role) {
      case "manager":
        toast("L'utilisateur " + userPromote.data.username + " est maintenant manager")
        break;
      case "admin":
        toast("L'utilisateur " + userPromote.data.username + " est maintenant administrateur")
        break;
      case "none":
        toast("L'utilisateur " + userPromote.data.username + " est maintenant user")
        break;
    }
  } catch (error) {
    console.error("Erreur lors de la promotion de l'utilisateur :", error);
  }
}

async function createTeam() {
  try {
    const userSearch = await axios.get(
      "https://api-time-manager.thomasbasquin.fr/api/users/",
      {
        params: {
          email: email_manager.value,
        },
      }
    );

    const userData = userSearch.data;
    console.log("Utilisateur récupéré :", userData);
    for (let i = 0; i < userData.data.length; i++) {
      if (userData.data[i].email === email_manager.value) {
        manager.value = userData.data[i];
      }
    }

    // Effectuer la requête POST pour créer l'utilisateur
    const response = await axios.post(
      "https://api-time-manager.thomasbasquin.fr/api/teams/",
      {
        team: {
          name: team_name.value,
          managers: [manager.value.id],
        },
      },
      {
        headers: {
          authorization: "Bearer " + localStorage.getItem("xsrf_token"),
        },
      }
    );
    // Traiter la réponse de l'API
    const team = response.data;
    toast("Team créée : " + team.data.name + " avec " + manager.value.username + " comme manager")
  } catch (error) {
    toast("Erreur lors de la création de la team")
    console.error("Erreur lors de la création de la team :", error);
  }
}

async function deleteUser() {
  try {
    const userSearch = await axios.get(
      "https://api-time-manager.thomasbasquin.fr/api/users/",
      {
        params: {
          email: email.value,
        },
      }
    );

    // Traiter la réponse de l'API
    const userData = userSearch.data;
    console.log("Utilisateur récupéré :", userData);
    for (let i = 0; i < userData.data.length; i++) {
      if (userData.data[i].email === email.value) {
        user.value = userData.data[i];
      }
    }

    // Effectuer la requête DELETE pour supprimer l'utilisateur
    const response = await axios.delete(
      "https://api-time-manager.thomasbasquin.fr/api/users/" + user.value.id,
      {
        headers: {
          authorization: "Bearer " + localStorage.getItem("xsrf_token"),
        },
      }
    );
    toast("L'utilisateur " + user.value.username + " a été supprimé")
  } catch (error) {
    console.error("Erreur lors de la suppression de l'utilisateur :", error);
    toast("Erreur lors de la suppression de l'utilisateur, veuillez vérifier l'email")
  }
}

async function fetchData() {
  try {
    const userSearch = await axios.get(
      "https://api-time-manager.thomasbasquin.fr/api/users/",
      {
        params: {
          email: search_bar.value,
        },
      }
    );

    // Traiter la réponse de l'API
    const userData = userSearch.data;
    console.log("Utilisateur récupéré :", userData);
    for (let i = 0; i < userData.data.length; i++) {
      if (userData.data[i].email === search_bar.value) {
        user.value = userData.data[i];
      }
    }
    await getWorkingTimes(user.value.id);
  } catch (error) {
    toast("Erreur lors de la récupération de l'utilisateur, veuillez vérifier l'email")
    console.error("Erreur lors de la récupération de l'utilisateur :", error);
  }
}
</script>

<template>
  <div class="w-screen h-full" v-if="renderComponent">
    <div v-if="isLoaded === false" class="flex items-center justify-center w-full h-full">
      <div class="flex items-center justify-center w-1/4 h-1/4 mt-10">
        <svg id="L2" enable-background="new 0 0 100 100" version="1.1" viewBox="0 0 100 100" x="0px" xml:space="preserve"
          xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" y="0px">
          <circle cx="50" cy="50" fill="none" r="48" stroke="#000000" stroke-miterlimit="10" stroke-width="4" />
          <line fill="none" stroke="#000000" stroke-linecap="round" stroke-miterlimit="10" stroke-width="4" x1="50"
            x2="85" y1="50" y2="50.5">
            <animateTransform attributeName="transform" dur="2s" from="0 50 50" repeatCount="indefinite" to="360 50 50"
              type="rotate" />
          </line>
          <line fill="none" stroke="#000000" stroke-linecap="round" stroke-miterlimit="10" stroke-width="4" x1="50"
            x2="49.5" y1="50" y2="74">
            <animateTransform attributeName="transform" dur="15s" from="0 50 50" repeatCount="indefinite" to="360 50 50"
              type="rotate" />
          </line>
        </svg>
      </div>
    </div>
    <div v-if="isLoaded === true" class="flex w-screen h-4/6 md:h-2/5 flex-col items-center mt-5">
      <div v-if="store.user.role === 'none'">
        Vous n'avez pas les droits nécessaires pour accéder à cette page.
      </div>
      <div v-if="store.user.role === 'admin' && status === 0"
        class="flex flex-col md:flex-row items-center justify-center space-y-2 md:space-y-0 md:space-x-2 ">
        <Card class="w-fit h-full">
          <CardHeader>
            <CardTitle>Promote/Demote User</CardTitle>
          </CardHeader>
          <CardContent class="items-center justify-between flex flex-col">
            <Input v-model="email" placeholder="Email" type="text" />

          </CardContent>
          <CardFooter>
            <div class="flex flex-row items-center justify-center space-x-1">
              <Button class="mt-2" @click="promoteUser('manager')">
                Manager
              </Button>
              <Button class="mt-2" @click="promoteUser('admin')">
                Admin
              </Button>
              <Button class="mt-2" @click="promoteUser('none')">
                Demote as user
              </Button>
              <Button class="mt-2" @click="deleteUser()">
                Delete user
              </Button>
            </div>
          </CardFooter>
        </Card>
        <Card class="w-fit h-full">
          <CardHeader>
            <CardTitle>Create team</CardTitle>
          </CardHeader>
          <CardContent class="items-center justify-center flex flex-col space-y-2">
            <Input v-model="team_name" placeholder="Name" type="text" />
            <Input v-model="email_manager" placeholder="Email Manager" type="email" />
            <div class="flex flex-row items-center justify-center space-x-2">
              <Button class="mt-2" @click="createTeam()">
                Create
              </Button>
            </div>
          </CardContent>
        </Card>
        <Button class="mt-2" @click="status = 1">See statistics</Button>
      </div>
      <div v-if="store.user.role === 'admin' && status === 1"
        class="flex flex-col items-center w-full h-full justify-center">
        <div class="flex flex-row items-center justify-center w-fit space-x-2">
          <Input v-model="search_bar" placeholder="Search an employee" type="text" />
          <Button @click="fetchData()">
            Fetch the data
          </Button>
        </div>
        <Card class="overflow-auto mt-4" v-if="isDataFetch === 1">
          <ul id="demo">
            <li v-for="wtime in workingtimes" class="item-{{$index}}">
              <Card class="m-3">
                <CardContent class="mt-5">
                  <CardTitle>{{ dateFormat(wtime.start) }} -
                    {{ dateFormat(wtime.end) }}</CardTitle>
                  <CardDescription>Status: Terminée</CardDescription>
                </CardContent>
              </Card>
            </li>
          </ul>
        </Card>
        <Button class="mt-2" @click="status = 0">Back to manage page</Button>
      </div>
      <div v-if="store.user.role === 'manager'" class="flex flex-col items-center w-full h-full justify-center">
        <div class="flex flex-row items-center justify-center w-fit space-x-2">
          <Input v-model="search_bar" placeholder="Search an employee" type="text" />
          <Button @click="fetchData()">
            Fetch the data
          </Button>
        </div>
        <Card class="overflow-auto mt-4">
          <ul id="demo">
            <li v-for="wtime in workingtimes" class="item-{{$index}}">
              <Card class="m-3">
                <CardContent class="mt-5">
                  <CardTitle>{{ dateFormat(wtime.start) }} -
                    {{ dateFormat(wtime.end) }}</CardTitle>
                  <CardDescription>Status: Terminée</CardDescription>
                </CardContent>
              </Card>
            </li>
          </ul>
        </Card>
      </div>
    </div>
  </div>
  <Toaster />
</template>
