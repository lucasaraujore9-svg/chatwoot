<script setup>
/* eslint-disable */
import { ref, computed } from 'vue';
const companies = ref([
  { id: 1, name: 'Acme Corp', domain: 'acme.com', contacts: 12, conversations: 34 },
  { id: 2, name: 'Globo Tech', domain: 'globo.tech', contacts: 5, conversations: 8 },
  { id: 3, name: 'Startup XYZ', domain: 'xyz.io', contacts: 2, conversations: 3 },
]);
const search = ref('');
const filtered = computed(() => companies.value.filter(c =>
  c.name.toLowerCase().includes(search.value.toLowerCase())
));
</script>
<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Empresas</h1>
      <button class="px-4 py-2 rounded-lg text-sm font-medium text-white" style="background: var(--accent)">+ Nova Empresa</button>
    </div>
    <input v-model="search" type="text" placeholder="Buscar empresa..."
           class="w-full px-3 py-2 border rounded-lg text-sm mb-4" />
    <div class="grid gap-4">
      <div v-for="c in filtered" :key="c.id"
           class="bg-white rounded-lg border border-slate-200 p-4 flex items-center justify-between hover:shadow-sm cursor-pointer">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-lg flex items-center justify-center text-white font-bold" style="background: var(--accent)">
            {{ c.name[0] }}
          </div>
          <div>
            <p class="text-sm font-semibold text-slate-800">{{ c.name }}</p>
            <p class="text-xs text-slate-400">{{ c.domain }}</p>
          </div>
        </div>
        <div class="flex gap-4 text-xs text-slate-500">
          <span>{{ c.contacts }} contatos</span>
          <span>{{ c.conversations }} conversas</span>
        </div>
      </div>
    </div>
  </div>
</template>
