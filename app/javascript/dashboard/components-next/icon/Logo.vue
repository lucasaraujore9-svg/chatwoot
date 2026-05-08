<script setup>
import { useAttrs } from 'vue';

const attrs = useAttrs();
</script>

<template>
  <svg
    v-bind="attrs"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 200 200"
    width="16"
    height="16"
    class="text-[#0E0E10] dark:text-[#FAFAF7]"
  >
    <path
      d="M 45,0 L 155,0 C 175.25,0 200,24.75 200,45 L 200,155 C 200,175.25 175.25,200 155,200 L 45,200 C 24.75,200 0,175.25 0,155 L 0,45 C 0,24.75 24.75,0 45,0 Z"
      fill="currentColor"
    />
    <circle cx="100" cy="42" r="7" fill="#FF5A1F" />
    <path
      d="M 56,72 L 144,72 C 152.8,72 160,79.2 160,88 L 160,124 C 160,132.8 152.8,140 144,140 L 110,140 L 92,160 L 92,140 L 56,140 C 47.2,140 40,132.8 40,124 L 40,88 C 40,79.2 47.2,72 56,72 Z"
      fill="#FF5A1F"
    />
  </svg>
</template>
