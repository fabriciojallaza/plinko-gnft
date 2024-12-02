<script lang="ts">
  import { balance } from '$lib/stores/game';
  import { flyAndScale } from '$lib/utils/transitions';
  import { Popover } from 'bits-ui';

  $: balanceFormatted = $balance.toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });

  const addMoneyAmounts = [100, 500, 1000];
  let isMetaMaskConnected = false;

  async function connectMetaMask() {
    if (typeof window.ethereum !== 'undefined') {
      try {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        if (accounts.length > 0) {
          isMetaMaskConnected = true;
        }
      } catch (error) {
        console.error('MetaMask connection failed:', error);
      }
    } else {
      console.error('MetaMask is not installed');
    }
  }
</script>

<div class="flex overflow-hidden rounded-md">
  <div
    class="flex gap-2 bg-slate-900 px-3 py-2 text-sm font-semibold tabular-nums text-white sm:text-base"
  >
    <span class="select-none text-gray-500">$GNFT</span>
    <span class="min-w-16 text-right">
      {balanceFormatted}
    </span>
  </div>
  <Popover.Root>
    <Popover.Trigger
      class="bg-blue-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-blue-500 active:bg-blue-700 sm:text-base"
    >
      Add
    </Popover.Trigger>
    <Popover.Content
      transition={flyAndScale}
      sideOffset={8}
      class="z-30 max-w-lg space-y-2 rounded-md bg-slate-600 p-3"
    >
      <p class="text-sm font-medium text-gray-200">Add money</p>
      <div class="flex gap-2">
        {#each addMoneyAmounts as amount}
          <button
            on:click={() => ($balance += amount)}
            class="touch-manipulation rounded-md bg-green-500 px-3 py-2 text-sm font-semibold text-gray-900 transition-colors hover:bg-green-400 active:bg-green-600 disabled:bg-neutral-600 disabled:text-neutral-400"
          >
            +${amount}
          </button>
        {/each}
      </div>
    </Popover.Content>
  </Popover.Root>
  {#if !isMetaMaskConnected}
    <button
      on:click={connectMetaMask}
      class="ml-2 rounded-md bg-yellow-500 px-4 py-2 text-sm font-medium text-gray-900 transition-colors hover:bg-yellow-400 active:bg-yellow-600"
    >
      Connect to MetaMask
    </button>
  {:else}
    <div class="ml-2 flex items-center gap-2">
      <span class="text-sm font-medium text-green-500">Connected</span>
      <img src="/path/to/metamask-logo.png" alt="MetaMask Logo" class="h-6 w-6" />
    </div>
  {/if}
</div>