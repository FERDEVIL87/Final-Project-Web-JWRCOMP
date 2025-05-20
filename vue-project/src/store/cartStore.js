// cartStore.js
import { reactive, computed } from 'vue';

export const cartStore = reactive({
  items: [],

  addItem(product) {
    // Check if item with same id and source already exists to increment quantity
    // For simplicity here, we'll assume each "add" is a new distinct line item if it's a complex package.
    // Or, if it's a simple product, you might want to find and increment qty.
    // For this example, we'll add as a new line item to keep it straightforward for diverse product types.
    
    const itemToAdd = { ...product };
    if (!itemToAdd.qty) { // Ensure quantity, default to 1
        itemToAdd.qty = 1;
    }
    this.items.push(itemToAdd);
    console.log("Cart after add:", JSON.parse(JSON.stringify(this.items))); // For deep logging
  },

  removeItem(compositeId) { // Use a composite ID like 'source-id'
    this.items = this.items.filter(item => `${item.source}-${item.id}` !== compositeId);
  },

  updateItemQuantity(compositeId, newQuantity) {
    const item = this.items.find(item => `${item.source}-${item.id}` === compositeId);
    if (item) {
      item.qty = Math.max(1, newQuantity); // Ensure qty is at least 1
    }
  },

  clearCart() {
    this.items = [];
  },

  // Use a computed property for total price for reactivity
  get totalPrice() {
    return this.items.reduce((sum, item) => {
        const price = Number(item.price) || 0;
        const qty = Number(item.qty) || 0;
        return sum + (price * qty);
    }, 0);
  }
});