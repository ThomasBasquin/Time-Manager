<script setup>
import { store } from '@/store.ts'
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card'
import axios from 'axios'
import { ref } from 'vue'
import moment from 'moment'
import Clock from "@/components/Clock.vue";

let workingtimes = ref([]);
let clock = ref([]);
let isLoaded = ref(false)

async function getWorkingTimes() {
    try {
        // Effectuer la requête GET pour récupérer les temps de travail
        const request = "http://157.230.19.19:4000/api/workingtimes/" + store.user.id
        const response = await axios.get(request, {})

        // Traiter la réponse de l'API
        store.workingtimes = response.data
        isLoaded.value = true
        console.log('working time récupéré :', store.workingtimes)
        store.workingtimes = store.workingtimes.reverse();
    } catch (error) {
        console.error('Erreur lors de la récupération de l\'utilisateur :', error)
    }
}

getWorkingTimes()

async function getClock() {
    try {
        // Effectuer la requête GET pour récupérer la clock
        const request = "http://157.230.19.19:4000/api/clocks/" + store.user.id
        const response = await axios.get(request, {})

        // Traiter la réponse de l'API
        store.clock = response.data
        console.log("la clock est: " + store.clock.status)
    } catch (error) {
        console.error('Erreur lors de la récupération de l\'utilisateur :', error)
    }
}

getClock()

const dateFormat = (dateOrigine) => {
 return moment(dateOrigine).format('D MMMM YYYY, HH:mm:ss');
} 

</script>

<template>
    <div v-if="!store.user.id" class="flex items-center mt-10 justify-center">
        <div class="text-center p-6 bg-white rounded-lg shadow-lg">
            <h2 class="text-2xl font-bold text-red-600 mb-3">Connectez-vous</h2>
            <p class="text-gray-700">
                Merci de vous connecter pour enregistrer votre temps de travail
            </p>
        </div>
    </div>
    <Card v-if="store.user.id" class="flex w-11/12">
        <Card class="w-1/4">
            <CardHeader class="">
                <CardTitle>Clock In/Out</CardTitle>
                <CardDescription></CardDescription>
            </CardHeader>
            <CardContent class="">
                <Clock />
            </CardContent>
            <CardFooter>
            </CardFooter>
        </Card>
        <Card v-if="isLoaded === true" class="w-3/4">
          <Card v-if="store.clock.status === true" class="m-3">
            <CardContent class="mt-5">
              <CardTitle>{{dateFormat(store.clock.start)}}</CardTitle>
              <CardDescription>Status: En cours</CardDescription>
            </CardContent>
          </Card>
            <ul id="demo">
                <li v-for="wtime in store.workingtimes" class="item-{{$index}}">
                    <Card class="m-3">
                        <CardContent class="mt-5">
                            <CardTitle>{{dateFormat(wtime.start)}} - {{dateFormat(wtime.end)}}</CardTitle>
                            <CardDescription>Status: Terminée</CardDescription>
                        </CardContent>
                    </Card>
                </li>
            </ul>

        </Card>
    </Card>
</template>