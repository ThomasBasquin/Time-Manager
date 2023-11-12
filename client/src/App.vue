<script setup lang="ts">
import Login from "@/components/Login.vue";
import WorkingTime from '@/components/WorkingTime.vue'
import WorkingTimes from "@/components/WorkingTimes.vue";
import Chart from "@/components/ChartManager.vue";
import Team from "@/components/Team.vue";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'
import { store } from "@/store.ts";
</script>

<template>
  <Tabs default-value="login" class="w-screen space-y-10">
    <TabsList class="md:grid w-full md:grid-rows-none md:grid-cols-5 mt-2" v-if="store.user.role === 'manager'">
      <TabsTrigger value="login">
        Account
      </TabsTrigger>
      <TabsTrigger value="WorkingTimes">
        Manage
      </TabsTrigger>
      <TabsTrigger value="WorkingTime">
        Working Time
      </TabsTrigger>
      <TabsTrigger value="Chart">
        Chart
      </TabsTrigger>
      <TabsTrigger value="Team">
        Your Team
      </TabsTrigger>
    </TabsList>
    <TabsList class="grid w-full grid-cols-4 mt-2" v-else>
      <TabsTrigger value="login">
        Account
      </TabsTrigger>
      <TabsTrigger value="WorkingTimes">
        Manage
      </TabsTrigger>
      <TabsTrigger value="WorkingTime">
        Working Time
      </TabsTrigger>
      <TabsTrigger value="Chart">
        Chart
      </TabsTrigger>
    </TabsList>
    <TabsContent value="login" class="justify-center items-center flex flex-col">
      <Login />
    </TabsContent>
    <TabsContent value="WorkingTimes" class="justify-center items-center flex flex-col">
      <WorkingTimes />
    </TabsContent>
    <TabsContent value="WorkingTime" class="justify-center items-center flex flex-col">
      <WorkingTime />
    </TabsContent>
    <TabsContent value="Chart" class="justify-center items-center flex flex-col h-full w-full">
      <Chart />
    </TabsContent>
    <TabsContent value="Team" class="justify-center items-center flex flex-col h-full w-full">
      <Suspense>
        <Team />
      </Suspense>
    </TabsContent>
  </Tabs>
</template>
