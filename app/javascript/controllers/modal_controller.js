import { Controller } from "@hotwired/stimulus"

shopId = null;

export default class extends Controller {
  static targets = ["myModal", "backGround"]

  connect() {
    const bookmarkButtons = document.getElementsByClassName("bookmark-icon");

    for (const bookmarkButton of bookmarkButtons) {
      bookmarkButton.addEventListener("click", this.buttonClick);
    }
  }
  
  close(event) {
    const clickedList = event.currentTarget;
    const listId = clickedList.getAttribute("data-list-id");

    if (shopId && listId) {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      
      fetch(`/shops/${shopId}/list_shops?list_id=${listId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken, 
        },
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('サーバーエラー');
        }
      })
      .then(data => {
        if (data.success) {
          this.setFlashMessage("success", `${data.name}へ保存しました`);
        } else {
          this.setFlashMessage("error", "すでに保存しています");
        }
      })
      .catch(error => {
        console.error("リクエストエラー", error);
        this.setFlashMessage("error", "リクエストエラーが発生しました");
      });
    }
    this.backGroundTarget.classList.add("hidden");
  }
  
  closeModal() {
    this.backGroundTarget.classList.add("hidden");
  }
  
  buttonClick(event) {
    const clickedButton = event.currentTarget;
    shopId = clickedButton.getAttribute("data-shop-id");
  }
  
  setFlashMessage(type, message) {
    const flashContainer = document.createElement("div");
    flashContainer.classList.add("flex", "items-center", "text-white", "text-xs", "md:text-sm", "font-bold", "pl-10", "py-5");
    
    if (type === "success") {
      flashContainer.classList.add("bg-green-400");
    } else if (type === "error") {
      flashContainer.classList.add("bg-red-400");
    }
    
    flashContainer.textContent = message;
    
    const flashContainerElement = document.getElementById("flash");
    
    if (flashContainerElement) {
      flashContainerElement.appendChild(flashContainer);
      setTimeout(() => {
        flashContainerElement.removeChild(flashContainer);
      }, 5000)
    }
  }

  closeBackground(event) {
    if(event.target === this.backGroundTarget) {
      this.closeModal();
    }
  }
}
