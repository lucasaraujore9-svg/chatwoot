<script setup>
/* eslint-disable */
import { ref, computed, nextTick, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'vuex';
import AgentsAPI from 'dashboard/api/atende/agents';

const route = useRoute();
const store = useStore();
const agentId = computed(() => route.params.agentId);

const agent = computed(() => store.getters['atende/agents/getAgent'](agentId.value));
const messages = ref([]);
const input = ref('');
const loading = ref(false);
const error = ref(null);
const showDebug = ref(true);
const debugInfo = ref(null);
const messagesContainer = ref(null);

onMounted(async () => {
  await store.dispatch('atende/agents/getAgent', agentId.value);
});

async function send() {
  const text = input.value.trim();
  if (!text || loading.value) return;

  messages.value.push({ role: 'user', content: text });
  input.value = '';
  error.value = null;
  loading.value = true;

  await scrollBottom();

  try {
    const { data } = await AgentsAPI.playground(agentId.value, { message: text });
    messages.value.push({ role: 'assistant', content: data.reply });
    debugInfo.value = data.debug || null;
  } catch (e) {
    error.value = e.response?.data?.error || 'Erro ao processar resposta.';
    messages.value.push({ role: 'assistant', content: error.value, isError: true });
  } finally {
    loading.value = false;
    await scrollBottom();
  }
}

async function scrollBottom() {
  await nextTick();
  if (messagesContainer.value) {
    messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
  }
}

function clearConversation() {
  messages.value = [];
  debugInfo.value = null;
  error.value = null;
}
</script>

<template>
  <!-- eslint-disable -->
  <div class="flex h-screen overflow-hidden">
    <!-- Chat area -->
    <div class="flex-1 flex flex-col min-w-0">
      <div class="px-4 py-3 border-b border-slate-200 bg-white flex items-center justify-between gap-2">
        <div class="flex items-center gap-2 min-w-0">
          <span class="text-sm font-medium text-slate-800 truncate">
            Playground — {{ agent?.name || 'Agente' }}
          </span>
          <span v-if="agent?.provider && agent?.model" class="px-2 py-0.5 rounded text-xs bg-green-100 text-green-700 flex-shrink-0">
            {{ agent.provider }} / {{ agent.model }}
          </span>
        </div>
        <button
          class="text-xs text-slate-400 hover:text-slate-600 flex-shrink-0"
          @click="clearConversation"
        >
          Limpar
        </button>
      </div>

      <div
        ref="messagesContainer"
        class="flex-1 overflow-y-auto p-4 space-y-3 bg-slate-50"
      >
        <div v-if="messages.length === 0" class="flex items-center justify-center h-full">
          <p class="text-sm text-slate-400">Envie uma mensagem para testar o agente.</p>
        </div>
        <div
          v-for="(msg, i) in messages"
          :key="i"
          :class="['flex', msg.role === 'user' ? 'justify-end' : 'justify-start']"
        >
          <div
            :class="[
              'px-3 py-2 rounded-lg text-sm max-w-sm whitespace-pre-wrap break-words',
              msg.role === 'user'
                ? 'bg-blue-600 text-white rounded-br-none'
                : msg.isError
                  ? 'bg-red-50 border border-red-200 text-red-700 rounded-bl-none'
                  : 'bg-white border border-slate-200 text-slate-800 rounded-bl-none',
            ]"
          >
            {{ msg.content }}
          </div>
        </div>
        <div v-if="loading" class="flex justify-start">
          <div class="px-3 py-2 rounded-lg bg-white border border-slate-200 text-slate-400 text-sm rounded-bl-none">
            <span class="animate-pulse">…</span>
          </div>
        </div>
      </div>

      <div class="p-3 border-t border-slate-200 bg-white flex gap-2">
        <input
          v-model="input"
          type="text"
          placeholder="Digite uma mensagem..."
          class="flex-1 px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:border-blue-400"
          :disabled="loading"
          @keyup.enter="send"
        />
        <button
          class="px-4 py-2 rounded-lg text-sm text-white font-medium bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
          :disabled="loading || !input.trim()"
          @click="send"
        >
          Enviar
        </button>
      </div>
    </div>

    <!-- Debug panel -->
    <aside v-if="showDebug" class="w-72 border-l border-slate-200 bg-white flex flex-col flex-shrink-0 overflow-y-auto">
      <div class="p-3 border-b border-slate-100 flex items-center justify-between">
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Debug</p>
        <button class="text-xs text-slate-400 hover:text-slate-600" @click="showDebug = false">✕</button>
      </div>
      <div class="p-3 space-y-2 text-xs text-slate-600">
        <template v-if="debugInfo">
          <div class="rounded bg-slate-50 p-2">
            <p class="font-medium text-slate-700">Iterações</p>
            <p>{{ debugInfo.iterations ?? '–' }}</p>
          </div>
          <div class="rounded bg-slate-50 p-2">
            <p class="font-medium text-slate-700">Tokens</p>
            <p>prompt: {{ debugInfo.prompt_tokens ?? '–' }} | completion: {{ debugInfo.completion_tokens ?? '–' }}</p>
          </div>
          <div class="rounded bg-slate-50 p-2">
            <p class="font-medium text-slate-700">Tools chamadas</p>
            <div v-if="debugInfo.tool_calls?.length">
              <div v-for="(tc, i) in debugInfo.tool_calls" :key="i" class="text-slate-500 font-mono">
                {{ tc.name }}({{ JSON.stringify(tc.args).slice(0, 60) }}…)
              </div>
            </div>
            <p v-else class="text-slate-400 italic">Nenhuma</p>
          </div>
          <div v-if="debugInfo.finish_reason" class="rounded bg-slate-50 p-2">
            <p class="font-medium text-slate-700">Motivo de parada</p>
            <p>{{ debugInfo.finish_reason }}</p>
          </div>
        </template>
        <p v-else class="text-slate-400 italic">Aguardando resposta…</p>
      </div>
    </aside>

    <button
      v-else
      class="absolute right-0 top-1/2 -translate-y-1/2 p-1 bg-white border border-slate-200 rounded-l text-xs text-slate-400 hover:text-slate-600"
      @click="showDebug = true"
    >
      Debug
    </button>
  </div>
</template>
