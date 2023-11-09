<script setup lang="ts">
import Login from "@/components/Login.vue";
import WorkingTime from '@/components/WorkingTime.vue'
import WorkingTimes from "@/components/WorkingTimes.vue";
import Chart from "@/components/ChartManager.vue";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'
</script>

<template>
  <Tabs default-value="login" class="w-screen">
    <TabsList class="grid w-full grid-cols-4">
      <TabsTrigger value="login">
        Account
      </TabsTrigger>
      <TabsTrigger value="WorkingTimes">
        Working Times
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
  </Tabs>
</template>
