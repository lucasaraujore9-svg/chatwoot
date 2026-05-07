<script setup>
/* eslint-disable */
import { ref } from 'vue';

const form = ref({
  name: '',
  description: '',
  provider: 'openai',
  model: 'gpt-4o',
  systemPrompt: '',
  temperature: 0.7,
  maxTokens: 1000,
  tools: {
    encaminhar_atendimento: false,
    adicionar_label: false,
    transferir_time: false,
    atualizar_atributo_contato: false,
    atualizar_atributo_conversa: false,
    salvar_variavel: false,
    finalizar_atendimento: false,
  },
});

const modelsByProvider = {
  openai: ['gpt-4o', 'gpt-4.1', 'o3', 'o4-mini'],
  anthropic: ['claude-opus-4-7', 'claude-sonnet-4-6', 'claude-haiku-4-5-20251001'],
  google: ['gemini-2.0-flash', 'gemini-2.0-pro'],
  ollama: ['llama3.3', 'mistral'],
};

const providers = ['openai', 'anthropic', 'google', 'ollama'];
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6 max-w-2xl">
    <h1 class="text-xl font-semibold text-slate-800 mb-6">Editor de Agente IA</h1>

    <div class="space-y-5">
      <div>
        <label class="block text-sm font-medium text-slate-700 mb-1">Nome</label>
        <input v-model="form.name" type="text" placeholder="Nome do agente"
               class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2"
               style="--tw-ring-color: var(--accent)" />
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-1">Provider</label>
          <select v-model="form.provider"
                  class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm">
            <option v-for="p in providers" :key="p" :value="p">{{ p }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-slate-700 mb-1">Modelo</label>
          <select v-model="form.model"
                  class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm">
            <option v-for="m in modelsByProvider[form.provider]" :key="m" :value="m">{{ m }}</option>
          </select>
        </div>
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-700 mb-1">System Prompt</label>
        <textarea v-model="form.systemPrompt" rows="5" placeholder="Instrução base do agente..."
                  class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm resize-none" />
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-700 mb-3">Tools habilitadas</label>
        <div class="grid grid-cols-2 gap-2">
          <label v-for="(enabled, tool) in form.tools" :key="tool"
                 class="flex items-center gap-2 text-sm text-slate-700 cursor-pointer">
            <input type="checkbox" v-model="form.tools[tool]" class="rounded" />
            {{ tool.replace(/_/g, ' ') }}
          </label>
        </div>
      </div>

      <div class="flex gap-3 pt-2">
        <button class="px-4 py-2 rounded-lg text-sm font-medium text-white"
                style="background: var(--accent)">
          Salvar Agente
        </button>
        <button class="px-4 py-2 rounded-lg text-sm font-medium border border-slate-200 text-slate-600">
          Cancelar
        </button>
      </div>
    </div>
  </div>
</template>
