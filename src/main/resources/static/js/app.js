/* Sprint 1: Klädbutik, Visa produkter, varukorg, lägg till, ta bort */

document.addEventListener("DOMContentLoaded", function () {

    var apiBase = (window.location.protocol === "file:") ? "http://localhost:8080" : "";

    // Hämta produkter
    var productList = document.getElementById("products");
    if (productList) {
        fetch(apiBase + "/api/products")
            .then(function (res) {
                if (!res.ok) throw new Error("Kunde inte hämta produkter. Öppna via http://localhost:8080");
                return res.json();
            })
            .then(function (products) {
                productList.innerHTML = "";
                if (!products || products.length === 0) {
                    productList.innerHTML = "<p>Inga produkter.</p>";
                    return;
                }
                products.forEach(function (p) {
                    var id = p.productId || p.product_id;
                    var name = p.name || "Produkt";
                    var price = p.price || 0;
                    var img = p.imagePath || p.image_path || "";
                    if (!img.startsWith("/")) img = "/" + img;
                    productList.innerHTML +=
                        '<article class="productCard">' +
                        '  <img src="' + img + '" alt="' + name + '">' +
                        '  <h3>' + name + '</h3>' +
                        '  <p>' + price + ' kr</p>' +
                        '  <button data-id="' + id + '" data-name="' + name + '" data-price="' + price + '" data-image="' + img + '">Lägg i varukorg</button>' +
                        '</article>';
                });
                productList.querySelectorAll("button").forEach(function (btn) {
                    btn.addEventListener("click", addToCart);
                });
            })
            .catch(function (err) {
                productList.innerHTML = '<p class="error-msg">Kunde inte hämta produkter. Kontrollera att Spring Boot och MySQL körs. Öppna sidan via <a href="http://localhost:8080">http://localhost:8080</a></p>';
            });
    }

    // Visa varukorg
    var cartItems = document.getElementById("cartItems");
    if (cartItems) {
        renderCart();
    }
});

function addToCart(e) {
    var btn = e.target;
    var product = {
        id: btn.dataset.id,
        name: btn.dataset.name,
        price: Number(btn.dataset.price),
        image: btn.dataset.image || "",
        quantity: 1
    };
    var cart = JSON.parse(localStorage.getItem("cart")) || [];
    var found = cart.find(function (item) { return item.id === product.id; });
    if (found) {
        found.quantity += 1;
    } else {
        cart.push(product);
    }
    localStorage.setItem("cart", JSON.stringify(cart));
    alert(product.name + " lades i varukorgen");
}

function renderCart() {
    var container = document.getElementById("cartItems");
    var subtotalEl = document.getElementById("subtotal");
    var totalEl = document.getElementById("total");
    var cart = JSON.parse(localStorage.getItem("cart")) || [];

    container.innerHTML = "";
    var total = 0;

    if (cart.length === 0) {
        container.innerHTML = "<p>Varukorgen är tom. <a href='index.html'>Fortsätt handla →</a></p>";
    } else {
        cart.forEach(function (item) {
            var lineTotal = item.price * item.quantity;
            total += lineTotal;
            var img = item.image || "";
            container.innerHTML +=
                '<article class="cartItem">' +
                '  <img src="' + img + '" alt="' + item.name + '">' +
                '  <div class="cartItemInfo">' +
                '    <h3>' + item.name + '</h3>' +
                '    <p>' + item.price + ' kr × ' + item.quantity + '</p>' +
                '    <p class="itemPrice">' + lineTotal + ' kr</p>' +
                '  </div>' +
                '  <button class="removeButton" data-id="' + item.id + '">Ta bort</button>' +
                '</article>';
        });
        container.querySelectorAll(".removeButton").forEach(function (btn) {
            btn.addEventListener("click", removeFromCart);
        });
    }

    if (subtotalEl) subtotalEl.textContent = total + " kr";
    if (totalEl) totalEl.textContent = total + " kr";
}

function removeFromCart(e) {
    var id = e.target.dataset.id;
    var cart = JSON.parse(localStorage.getItem("cart")) || [];
    cart = cart.filter(function (item) { return item.id !== id; });
    localStorage.setItem("cart", JSON.stringify(cart));
    renderCart();
}
