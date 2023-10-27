<script setup lang="ts" >
import { ref } from 'vue';
import { store } from '@/store.ts';
import { Button } from './ui/button';
import axios from 'axios'
import moment from 'moment'

let workingtimes = ref([]);
let isLoaded = ref(false)


getWorkingTimes()
async function getWorkingTimes() {
  axios.get('http://localhost:4000/api/workingtimes/' + store.user.id)
  .then(function (response: { data: any; }) {
    // Gérer la réponse ici
    workingtimes = response.data
    console.log(response.data);
    console.log(workingtimes)
    isLoaded.value = true
  })
  .catch(function (error: any) {
    // Gérer les erreurs ici
    console.error(error);
  });
}
const Username = ref('Username')
const UserID = ref('UserID')
const Clockin = ref('Clock in')
const Clockout = ref('Clock out')
const WorkTime = ref('Work Time')

const dateFormatee = (dateOrigine) => {
 return moment(dateOrigine).format('D MMMM YYYY, HH:mm:ss');
} 
</script>


<template>
<li v-if="isLoaded === true" v-for="workingtime in workingtimes">
  {{ Username }} - {{ workingtime.user.username }} - {{ UserID }} - {{ workingtime.user.id }} - {{ Clockin }} - {{ dateFormatee(workingtime.start) }} - {{ Clockout }} - {{ dateFormatee(workingtime.end) }} - {{ WorkTime }} - {{ workingtime.id }}
</li>

</template>