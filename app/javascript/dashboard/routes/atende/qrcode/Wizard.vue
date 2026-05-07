<script setup>
/* eslint-disable */
import { ref, onUnmounted } from 'vue';
import QrcodeInboxesAPI from 'dashboard/api/atende/qrcode_inboxes';

const emit = defineEmits(['created', 'cancel']);

const step = ref(1);
const form = ref({ name: '', proxy_url: '' });
const loading = ref(false);
const error = ref(null);
const qrCode = ref(null);
const channelId = ref(null);
const inboxId = ref(null);
const qrStatus = ref('disconnected');

let pollTimer = null;

async function createInbox() {
  loading.value = true;
  error.value = null;
  try {
    const { data } = await QrcodeInboxesAPI.create({
      name: form.value.name || 'QrCode WhatsApp',
      proxy_url: form.value.proxy_url || null,
    });
    channelId.value = data.channel_id;
    inboxId.value = data.inbox_id;
    qrCode.value = data.qr_code;
    step.value = 2;
    startPolling();
  } catch (e) {
    error.value = e.response?.data?.error || 'Erro ao criar inbox.';
  } finally {
    loading.value = false;
  }
}

function startPolling() {
  pollTimer = setInterval(async () => {
    if (!channelId.value) return;
    try {
      const { data } = await QrcodeInboxesAPI.getQrCode(channelId.value);
      qrCode.value = data.qr_code || qrCode.value;
      qrStatus.value = data.status;
      if (data.status === 'connected') {
        stopPolling();
        step.value = 3;
      } else if (data.status === 'failed') {
        stopPolling();
        error.value = 'Conexão falhou. Tente novamente.';
      }
    } catch { /* ignore transient errors */ }
  }, 3000);
}

function stopPolling() {
  if (pollTimer) clearInterval(pollTimer);
  pollTimer = null;
}

onUnmounted(stopPolling);

function finish() {
  emit('created', { inbox_id: inboxId.value });
}

function prev() {
  if (step.value === 1) {
    emit('cancel');
  } else {
    step.value--;
    stopPolling();
  }
}
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6 max-w-lg mx-auto">
    <h2 class="text-xl font-semibold text-slate-800 mb-1">WhatsApp via QR Code</h2>
    <p class="text-sm text-slate-500 mb-6">Conecte um número WhatsApp sem a API oficial.</p>

    <!-- Step indicator -->
    <div class="flex items-center gap-2 mb-8">
      <div
        v-for="s in 3"
        :key="s"
        :class="[
          'w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold transition-colors',
          s === step ? 'bg-orange-500 text-white' : s < step ? 'bg-green-500 text-white' : 'bg-slate-100 text-slate-400',
        ]"
      >
        <span v-if="s < step">✓</span>
        <span v-else>{{ s }}</span>
      </div>
      <div class="h-px flex-1 bg-slate-200" />
    </div>

    <!-- Error -->
    <div v-if="error" class="mb-4 px-4 py-2 bg-red-50 border border-red-200 rounded-lg text-sm text-red-700">
      {{ error }}
    </div>

    <!-- Step 1: Config -->
    <div v-if="step === 1" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-slate-700 mb-1">Nome do canal</label>
        <input
          v-model="form.name"
          type="text"
          class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:border-orange-400"
          placeholder="Ex: Suporte WhatsApp"
        />
      </div>
      <div>
        <label class="block text-sm font-medium text-slate-700 mb-1">
          Proxy URL
          <span class="text-slate-400 font-normal text-xs">(opcional)</span>
        </label>
        <input
          v-model="form.proxy_url"
          type="text"
          class="w-full px-3 py-2 border border-slate-200 rounded-lg text-sm focus:outline-none focus:border-orange-400"
          placeholder="http://proxy:8080"
        />
        <p class="text-xs text-slate-400 mt-1">Configure um proxy HTTP para esta conexão específica.</p>
      </div>
    </div>

    <!-- Step 2: QR Code -->
    <div v-if="step === 2" class="text-center">
      <p class="text-sm text-slate-600 mb-4">
        Abra o WhatsApp → Dispositivos conectados → Conectar dispositivo → Escaneie o QR:
      </p>
      <div class="w-52 h-52 mx-auto rounded-xl overflow-hidden border-2 border-slate-200 flex items-center justify-center bg-white">
        <img v-if="qrCode" :src="`data:image/png;base64,${qrCode}`" alt="QR Code" class="w-full h-full object-contain" />
        <div v-else class="flex flex-col items-center gap-2">
          <div class="w-8 h-8 border-2 border-orange-400 border-t-transparent rounded-full animate-spin" />
          <p class="text-xs text-slate-400">Gerando QR Code…</p>
        </div>
      </div>
      <p class="text-xs text-slate-400 mt-3">
        <span v-if="qrStatus === 'qr_pending'">Aguardando leitura…</span>
        <span v-else-if="qrStatus === 'disconnected'">Conectando ao servidor…</span>
        <span v-else>{{ qrStatus }}</span>
      </p>
    </div>

    <!-- Step 3: Connected -->
    <div v-if="step === 3" class="text-center space-y-3">
      <div class="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto">
        <span class="text-green-600 text-3xl">✓</span>
      </div>
      <p class="text-base font-semibold text-slate-800">Conectado!</p>
      <p class="text-sm text-slate-500">
        O canal <strong>{{ form.name || 'QrCode WhatsApp' }}</strong> está ativo e pronto para receber mensagens.
      </p>
    </div>

    <!-- Navigation -->
    <div class="flex justify-between mt-8">
      <button
        class="px-4 py-2 text-sm border border-slate-200 rounded-lg text-slate-600 hover:bg-slate-50"
        :disabled="loading"
        @click="prev"
      >
        {{ step === 1 ? 'Cancelar' : 'Voltar' }}
      </button>

      <button
        v-if="step === 1"
        class="px-5 py-2 text-sm text-white rounded-lg font-medium bg-orange-500 hover:bg-orange-600 disabled:opacity-50"
        :disabled="loading || !form.name.trim()"
        @click="createInbox"
      >
        <span v-if="loading">Criando…</span>
        <span v-else>Criar Inbox →</span>
      </button>

      <button
        v-if="step === 3"
        class="px-5 py-2 text-sm text-white rounded-lg font-medium bg-green-600 hover:bg-green-700"
        @click="finish"
      >
        Concluir
      </button>
    </div>
  </div>
</template>
