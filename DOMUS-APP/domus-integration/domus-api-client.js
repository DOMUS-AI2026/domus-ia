/**
 * DOMUS AI — cliente da API (usar no domus-app.html no lugar do estado local).
 *
 * Como usar: <script src="domus-api-client.js"></script>  (antes do script principal)
 * Depois é só chamar DomusAPI.fetchRooms(1) etc.
 */
const DomusAPI = (() => {
  const BASE = window.DOMUS_API_BASE || "http://localhost:8000";

  async function request(path, options = {}) {
    const res = await fetch(BASE + path, {
      headers: { "Content-Type": "application/json" },
      ...options,
    });
    if (!res.ok) throw new Error(`DOMUS API ${res.status}: ${await res.text()}`);
    return res.status === 204 ? null : res.json();
  }

  // ---- Ambientes (planta 2D/3D) ----
  const fetchRooms = (homeId) => request(`/homes/${homeId}/rooms`);

  // ---- Dispositivos ----
  const sendCommand = (homeId, slug, key, action = "toggle") =>
    request(`/homes/${homeId}/rooms/${slug}/devices/${key}/command`, {
      method: "POST",
      body: JSON.stringify({ action, issued_by: "user" }),
    });

  // ---- Simulador ----
  const simulate = (homeId, scenario, roomSlug = null) =>
    request(`/homes/${homeId}/simulate`, {
      method: "POST",
      body: JSON.stringify({ scenario, room_slug: roomSlug }),
    });

  // ---- Alert Center ----
  const fetchAlerts = (homeId) => request(`/homes/${homeId}/alerts`);
  const resolveAlert = (homeId, alertId) =>
    request(`/homes/${homeId}/alerts/${alertId}/resolve`, { method: "POST" });

  // ---- DOMUS Score ----
  const fetchScore = (homeId) => request(`/homes/${homeId}/score`);

  // ---- Automação ----
  const fetchAutomations = (homeId) => request(`/homes/${homeId}/automations`);
  const toggleAutomation = (homeId, ruleKey) =>
    request(`/homes/${homeId}/automations/${ruleKey}/toggle`, { method: "POST" });

  /**
   * Converte a resposta da API (lista de RoomOut, com sensors[] e devices[] separados)
   * para o MESMO formato de objeto `rooms` usado no protótipo front-end
   * (um dict por slug, com sensors mesclados num único {chave: valor}).
   * Isso permite reaproveitar 100% do código de render (buildPlant2D, buildScene3D, painel...).
   */
  function mapRoomsToLocalState(apiRooms) {
    const rooms = {};
    apiRooms.forEach((r) => {
      const sensors = {};
      r.sensors.forEach((s) => (sensors[s.key_name] = s.last_value));
      r.devices.forEach((d) => (sensors[d.key_name] = d.state));
      rooms[r.slug] = {
        id: r.id,
        name: r.name,
        area: r.area_m2,
        x: r.pos_x, z: r.pos_z, w: r.width_m, d: r.depth_m,
        px: { x: r.pos_x * 100, y: r.pos_z * 100, w: r.width_m * 100, h: r.depth_m * 100 },
        status: r.status,
        sensors,
      };
    });
    return rooms;
  }

  return {
    fetchRooms, sendCommand, simulate, fetchAlerts, resolveAlert,
    fetchScore, fetchAutomations, toggleAutomation, mapRoomsToLocalState,
  };
})();
