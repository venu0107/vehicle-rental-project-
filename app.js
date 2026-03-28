// Simulated Database using LocalStorage for UI Demonstration
const INITIAL_VEHICLES = [
    { id: 101, name: "Mercedes G-Wagon", type: "Luxury SUV", price: 500, status: "available" },
    { id: 102, name: "Porsche 911", type: "Sports Coupe", price: 800, status: "available" },
    { id: 103, name: "Lamborghini Urus", type: "Super SUV", price: 1200, status: "booked" }
];

function initDB() {
    if (!localStorage.getItem("vehicles")) {
        localStorage.setItem("vehicles", JSON.stringify(INITIAL_VEHICLES));
    }
}

function getVehicles() {
    return JSON.parse(localStorage.getItem("vehicles") || "[]");
}

function addVehicle(name, type, price) {
    const vehicles = getVehicles();
    const newId = vehicles.length > 0 ? Math.max(...vehicles.map(v => v.id)) + 1 : 100;
    vehicles.push({ id: newId, name, type, price: parseInt(price), status: "available" });
    localStorage.setItem("vehicles", JSON.stringify(vehicles));
}

function updateVehicleStatus(id, newStatus) {
    const vehicles = getVehicles();
    const index = vehicles.findIndex(v => v.id === id);
    if (index !== -1) {
        vehicles[index].status = newStatus;
        localStorage.setItem("vehicles", JSON.stringify(vehicles));
    }
}

function deleteVehicle(id) {
    let vehicles = getVehicles();
    vehicles = vehicles.filter(v => v.id !== id);
    localStorage.setItem("vehicles", JSON.stringify(vehicles));
}

// Initialize on load
initDB();
