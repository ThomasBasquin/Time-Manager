<script setup lang="ts">
  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card";
  import { Input } from "@/components/ui/input";
  import { Button } from "@/components/ui/button";
  import { ref } from "vue";

  const working = ref(false);
  const dateStart = ref(new Date());
  const dateEnd = ref(new Date());

  function toggleWorkStatus() {
    working.value = !working.value;
    if (working.value) {
      dateEnd.value = null;
      dateStart.value = new Date();
    } else {
      dateEnd.value = new Date();
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
