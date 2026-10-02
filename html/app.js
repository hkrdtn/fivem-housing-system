const app = document.getElementById('app');
const houseList = document.getElementById('houseList');
const closeBtn = document.getElementById('closeBtn');

function formatMoney(value) {
    return new Intl.NumberFormat('cs-CZ').format(value || 0) + ' $';
}

function renderHouses(houses) {
    houseList.innerHTML = '';

    if (!houses || houses.length === 0) {
        houseList.innerHTML = '<div class="empty-state">Žádné nemovitosti nebyly nalezeny.</div>';
        return;
    }

    houses.forEach((house) => {
        const card = document.createElement('div');
        card.className = 'house-card';

        const name = document.createElement('div');
        name.className = 'house-name';
        name.textContent = house.name;

        const meta = document.createElement('div');
        meta.className = 'house-meta';
        meta.innerHTML = `
            <div><strong>Cena:</strong> ${formatMoney(house.price)}</div>
            <div><strong>Majitel:</strong> ${house.owner_name || '🟢 Volné'}</div>
            <div><strong>Stav:</strong> ${house.locked ? '🔒 Zamčeno' : '🔓 Odemčeno'}</div>
            <div><strong>Garáž:</strong> ${house.garage_enabled ? '✅ Ano' : '❌ Ne'}</div>
        `;

        const actions = document.createElement('div');
        actions.className = 'house-actions';

        if (!house.owner) {
            const buyBtn = document.createElement('button');
            buyBtn.textContent = '🏠 Koupit';
            buyBtn.className = 'btn-primary';
            buyBtn.onclick = () => fetch(`https://${GetParentResourceName()}/buyHouse`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ id: house.id })
            });
            actions.appendChild(buyBtn);
        } else {
            const sellBtn = document.createElement('button');
            sellBtn.textContent = '💰 Prodat';
            sellBtn.className = 'btn-secondary';
            sellBtn.onclick = () => {
                if (confirm('Prodáš dům za 70% ceny?')) {
                    fetch(`https://${GetParentResourceName()}/sellHouse`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                        body: JSON.stringify({ id: house.id })
                    });
                }
            };
            actions.appendChild(sellBtn);
        }

        const enterBtn = document.createElement('button');
        enterBtn.textContent = '🚪 Vstoupit';
        enterBtn.className = 'btn-secondary';
        enterBtn.onclick = () => fetch(`https://${GetParentResourceName()}/enterHouse`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ id: house.id })
        });
        actions.appendChild(enterBtn);

        if (house.garage_enabled) {
            const garageBtn = document.createElement('button');
            garageBtn.textContent = '🚗 Garáž';
            garageBtn.className = 'btn-secondary';
            garageBtn.onclick = () => fetch(`https://${GetParentResourceName()}/openGarage`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ id: house.id })
            });
            actions.appendChild(garageBtn);
        }

        const inventoryBtn = document.createElement('button');
        inventoryBtn.textContent = '📦 Sklad';
        inventoryBtn.className = 'btn-secondary';
        inventoryBtn.onclick = () => fetch(`https://${GetParentResourceName()}/openInventory`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ id: house.id })
        });
        actions.appendChild(inventoryBtn);

        if (house.owner) {
            const lockBtn = document.createElement('button');
            lockBtn.textContent = house.locked ? '🔓 Odemknout' : '🔒 Zamknout';
            lockBtn.className = 'btn-danger';
            lockBtn.onclick = () => fetch(`https://${GetParentResourceName()}/toggleLock`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ id: house.id })
            });
            actions.appendChild(lockBtn);
        }

        card.appendChild(name);
        card.appendChild(meta);
        card.appendChild(actions);
        houseList.appendChild(card);
    });
}

function closeMenu() {
    app.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({})
    });
}

closeBtn.addEventListener('click', closeMenu);
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') closeMenu();
});

window.addEventListener('message', (event) => {
    const data = event.data || {};
    if (data.type === 'openMenu') {
        renderHouses(data.houses || []);
        app.classList.remove('hidden');
    }
});
