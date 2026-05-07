<script setup>
/* eslint-disable */
import { ref, watch, onUnmounted, nextTick } from 'vue';
import { createConsumer } from '@rails/actioncable';
import CopilotAPI from 'dashboard/api/atende/copilot';

const props = defineProps({
  isOpen: { type: Boolean, default: false },
  conversationId: { type: [Number, String], default: null },
  accountId: { type: [Number, String], required: true },
});
const emit = defineEmits(['close', 'use-suggestion']);

const activeTab = ref('suggestions');
const messages = ref([]);
const chatInput = ref('');
const loading = ref(false);
const typing = ref(false);
const threadId = ref(null);
const error = ref(null);
const messagesEl = ref(null);

let subscription = null;
let consumer = null;

watch(
  () => [props.isOpen, props.conversationId],
  async ([open, convId]) => {
    if (open && convId) {
      await initThread(convId);
    } else if (!open) {
      disconnectCable();
    }
  },
  { immediate: true }
);

onUnmounted(disconnectCable);

async function initThread(convId) {
  loading.value = true;
  error.value = null;
  try {
    const { data } = await CopilotAPI.getOrCreateThread(convId);
    threadId.value = data.id;
    const { data: msgData } = await CopilotAPI.getMessages(data.id);
    messages.value = msgData.messages || [];
    connectCable(data.id);
    await scrollBottom();
  } catch {
    error.value = 'Erro ao conectar ao Copilot.';
  } finally {
    loading.value = false;
  }
}

function connectCable(tId) {
  disconnectCable();
  consumer = createConsumer();
  subscription = consumer.subscriptions.create(
    {
      channel: 'Atende::CopilotChannel',
      thread_id: tId,
      account_id: props.accountId,
    },
    {
      received(data) {
        if (data.type === 'typing') {
          typing.value = true;
        } else if (data.type === 'message') {
          typing.value = false;
          messages.value.push({ role: data.role, content: data.content });
          scrollBottom();
        } else if (data.type === 'error') {
          typing.value = false;
          error.value = `Erro do Copilot: ${data.code}`;
        }
      },
    }
  );
}

function disconnectCable() {
  if (subscription) subscription.unsubscribe();
  if (consumer) consumer.disconnect();
  subscription = null;
  consumer = null;
}

async function send() {
  const text = chatInput.value.trim();
  if (!text || loading.value || !threadId.value) return;

  messages.value.push({ role: 'user', content: text });
  chatInput.value = '';
  error.value = null;
  await CopilotAPI.sendMessage(threadId.value, text);
  await scrollBottom();
}

async function scrollBottom() {
  await nextTick();
  if (messagesEl.value) messagesEl.value.scrollTop = messagesEl.value.scrollHeight;
}

function useSuggestion(text) {
  emit('use-suggestion', text);
}

const suggestions = ref([
  { id: 1, text: 'Olá! Fico feliz em ajudar. Como posso te auxiliar hoje?' },
  { id: 2, text: 'Para verificar o status do seu pedido, preciso de mais alguns dados.' },
]);
</script>

<template>
  <!-- eslint-disable -->
  <div
    v-if="isOpen"
    class="fixed right-0 top-0 h-full w-80 bg-white shadow-xl border-l border-slate-200 flex flex-col z-40"
  >
    <!-- Header -->
    <div class="flex items-center justify-between px-4 py-3 border-b border-slate-200 flex-shrink-0">
      <span class="text-sm font-semibold text-slate-800">Copilot IA</span>
      <button class="text-slate-400 hover:text-slate-700 text-lg leading-none" @click="$emit('close')">×</button>
    </div>

    <!-- Tabs -->
    <div class="flex border-b border-slate-200 flex-shrink-0">
      <button
        v-for="tab in ['suggestions', 'chat']"
        :key="tab"
        :class="[
          'flex-1 py-2 text-xs font-medium transition-colors',
          activeTab === tab ? 'border-b-2 border-blue-500 text-slate-800' : 'text-slate-400 hover:text-slate-600',
        ]"
        @click="activeTab = tab"
      >
        {{ tab === 'suggestions' ? 'Sugestões' : 'Chat IA' }}
      </button>
    </div>

    <!-- Error banner -->
    <div v-if="error" class="px-4 py-2 bg-red-50 border-b border-red-200 text-xs text-red-600 flex-shrink-0">
      {{ error }}
    </div>

    <!-- Suggestions tab -->
    <div v-if="activeTab === 'suggestions'" class="flex-1 overflow-y-auto p-4 space-y-3">
      <div v-for="s in suggestions" :key="s.id" class="rounded-lg border border-slate-200 p-3">
        <p class="text-sm text-slate-700 mb-2">{{ s.text }}</p>
        <div class="flex gap-2">
          <button
            class="text-xs px-3 py-1 rounded bg-blue-600 text-white hover:bg-blue-700"
            @click="useSuggestion(s.text)"
          >
            Usar
          </button>
        </div>
      </div>
    </div>

    <!-- Chat tab -->
    <template v-else>
      <div
        ref="messagesEl"
        class="flex-1 overflow-y-auto p-3 space-y-2"
      >
        <div v-if="loading" class="text-xs text-slate-400 text-center py-4">Carregando…</div>
        <div v-else-if="messages.length === 0" class="text-xs text-slate-400 text-center py-8">
          Envie uma mensagem para o Copilot.
        </div>
        <div
          v-for="(msg, i) in messages"
          :key="i"
          :class="['flex', msg.role === 'user' ? 'justify-end' : 'justify-start']"
        >
          <div
            :class="[
              'px-3 py-2 rounded-lg text-xs max-w-[220px] whitespace-pre-wrap break-words',
              msg.role === 'user'
                ? 'bg-blue-600 text-white rounded-br-none'
                : 'bg-slate-100 text-slate-800 rounded-bl-none',
            ]"
          >
            {{ msg.content }}
            <div v-if="msg.role === 'assistant'" class="mt-1 flex justify-end">
              <button
                class="text-xs text-blue-600 hover:underline"
                @click="useSuggestion(msg.content)"
              >
                Usar
              </button>
            </div>
          </div>
        </div>
        <div v-if="typing" class="flex justify-start">
          <div class="px-3 py-2 rounded-lg bg-slate-100 text-xs text-slate-500 rounded-bl-none animate-pulse">
            Digitando…
          </div>
        </div>
      </div>

      <div class="p-3 border-t border-slate-200 flex gap-2 flex-shrink-0">
        <input
          v-model="chatInput"
          type="text"
          placeholder="Pergunte ao Copilot…"
          class="flex-1 px-2 py-1.5 border border-slate-200 rounded text-xs focus:outline-none focus:border-blue-400"
          :disabled="loading || !threadId"
          @keyup.enter="send"
        />
        <button
          class="px-3 py-1.5 rounded text-xs text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
          :disabled="loading || !chatInput.trim() || !threadId"
          @click="send"
        >
          Enviar
        </button>
      </div>
    </template>
  </div>
</template>
