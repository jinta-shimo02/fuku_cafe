import { Controller } from "@hotwired/stimulus"

shopId = null;

export default class extends Controller {
  static targets = ["myModal"]

  connect() {
    // "bookmark-icon" クラスの要素を取得
    const bookmarkButtons = document.getElementsByClassName("bookmark-icon");
      
    // 各ブックマークボタンにクリックイベントリスナーを追加
    for (const bookmarkButton of bookmarkButtons) {
      bookmarkButton.addEventListener("click", this.buttonClick);
    }
  }

  open() {
    this.myModalTarget.classList.remove('hidden');
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
          'X-CSRF-Token': csrfToken, // CSRFトークンを追加
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
          this.setFlashMessage("error", `すでに保存しています`);
        }
      })
      .catch(error => {
        console.error("リクエストエラー", error);
        this.setFlashMessage("error", "リクエストエラーが発生しました");
      });
    }
    this.myModalTarget.classList.add("hidden");
  }

  new_list_close(event) {
      this.myModalTarget.classList.add("hidden");
  }

  buttonClick(event) {
    // クリックされたブックマークボタンから data-shop-id を取得
    const clickedButton = event.currentTarget;
    shopId = clickedButton.getAttribute("data-shop-id"); // グローバル変数に代入
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
}
