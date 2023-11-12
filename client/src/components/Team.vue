<script setup>
import { store } from "@/store.ts";
import axios from "axios";
import { ref } from "vue";
import { dateFormat } from "@/utils/date";
import { Card, CardContent, CardDescription, CardTitle } from "@/components/ui/card";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
let workingTimes = ref([]);
let isLoaded = ref(false);
let email = ref("");

let user_teams = [];

// Get the number of working times of the team today
async function getTodayWorkingTimes() {
    let todayWorkingTimes = [];
    console.log(store.team_workingtimes);
    let team_workingtimes = Array.from(store.team_workingtimes);
    team_workingtimes.forEach((workingTime) => {
        if (workingTime.start.includes(new Date().toISOString().slice(0, 10))) {
            todayWorkingTimes.push(workingTime);
        }
    });
    console.log(todayWorkingTimes);
    return todayWorkingTimes;
}


async function getTeam() {
    const response = await axios.get("https://api-time-manager.thomasbasquin.fr/api/teams/")
    store.teams = Array.from(response.data.data);
    // Parse all team in teams and get the team if the store.user.id is in the managers array
    store.teams.forEach((team) => {
        if (team.managers.includes(store.user.id)) {
            store.team = team;
        }
    });
    console.log(store.team);
    await getUsers();
}

async function getWorkingTimes() {
    const response = await axios.get("https://api-time-manager.thomasbasquin.fr/api/workingtimes/")
    let workingTimes = Array.from(response.data);
    let FilteredWorkingTimes = [];
    // Get only the working times of the team by reading in foreach workingtime the user_id and check if the user is in the team
    workingTimes.forEach((workingTime) => {
        user_teams.forEach((user) => {
            if (workingTime.user_id == user.id) {
                FilteredWorkingTimes.push(workingTime);
            }
        });
    });
    console.log(FilteredWorkingTimes);
    FilteredWorkingTimes.sort((a, b) => {
        return new Date(b.start) - new Date(a.start);
    });
    store.team_today_workingtimes = await getTodayWorkingTimes();
    return FilteredWorkingTimes;
}

async function getUsers() {
    const response = await axios.get("https://api-time-manager.thomasbasquin.fr/api/users/")
    console.log(response.data.data)
    let users = Array.from(response.data.data);
    // Get all the users by reading the store.users.teams array and add the
    users.forEach((user) => {
        if (user.teams.includes(store.team.id)) {
            console.log(user);
            user_teams.push(user);
        }
    });
    console.log(user_teams);
    isLoaded.value = true;
    store.team_workingtimes = await getWorkingTimes();
    console.log(store.team_workingtimes);
}

async function addUser() {
    console.log(email.value);
    const response = await axios.get(
        "https://api-time-manager.thomasbasquin.fr/api/users/",
        {
            params: {
                email: email.value,
            },
        }
    );

    // Traiter la réponse de l'API
    const user = response.data.data[0];
    console.log("Utilisateur récupéré :", user);
    const response2 = await axios.put(
        "https://api-time-manager.thomasbasquin.fr/api/users/" + user.id,
        {
            user: {
                email: user.email,
                username: user.username,
                teams: [...user.teams, store.team.id],
            },
        }
    );
    console.log(response2.data);
}



await getTeam();
</script>
<template>
    <div class="flex items-center justify-center flex-col">
        <div class="flex flex-col md:flex-row space-x-10 items-center justify-center">
            <Card class="flex flex-col items-center justify-center my-2 space-y-3">
                <CardTitle class="mt-2">
                    Add a new user
                </CardTitle>
                <CardContent>
                    <CardDescription>
                        <Input placeholder="Email" class="w-full" v-model="email" />
                        <Button class="w-full" @click="addUser">Add</Button>
                    </CardDescription>
                </CardContent>
            </Card>
            <Card class="flex flex-col items-center justify-center my-2 space-y-3">
                <CardTitle class="mt-2">
                    Statistics
                </CardTitle>
                <CardContent>
                    <CardDescription>
                        <p>Number of users : {{ user_teams.length }}</p>
                        <p>Number of working times : {{ store.team_workingtimes.length }}</p>
                        <p>Number of working times today : {{ store.team_today_workingtimes.length }} / {{ user_teams.length
                        }}</p>
                    </CardDescription>
                </CardContent>
            </Card>
        </div>
        <ul class="flex flex-col items-center justify-center w-screen">
            <li v-for="workingTime in store.team_workingtimes" :key="workingTime.id"
                class="flex flex-col items-center justify-center overflow-y-auto">
                <Card class="flex flex-col items-center justify-center my-2 h-2/5">
                    <CardTitle>
                        {{ workingTime.user.username }}
                    </CardTitle>
                    <CardContent>
                        <CardDescription>
                            {{ dateFormat(workingTime.start) }} - {{ dateFormat(workingTime.end) }}
                        </CardDescription>
                    </CardContent>
                </Card>
            </li>
        </ul>
    </div>
</template>