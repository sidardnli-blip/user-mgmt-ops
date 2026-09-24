// Aufgabe 2: kontrolliert steigende Last auf den user_mgmt_service.
//
// Der Test laeuft im Cluster und geht bewusst ueber den NGINX Ingress Controller,
// damit die Requests per Round Robin auf alle verfuegbaren Backend-Replicas
// verteilt werden (vordefinierte Lastverteilungsstrategie).
import http from 'k6/http';
import { check, sleep, fail } from 'k6';

const BASE = __ENV.TARGET_URL || 'http://ingress-nginx-controller.ingress-nginx.svc.cluster.local';
const HOST = __ENV.TARGET_HOST || 'localhost';
const PASSWORD = 'k6-load-test-1234';

export const options = {
  // Stufenweise steigende Last, danach wieder runter -> HPA skaliert hoch und runter
    stages: [
    { duration: '1m', target: 8 },
    { duration: '2m', target: 20 },
    { duration: '3m', target: 30 },
    { duration: '2m', target: 30 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    // Verfuegbarkeit waehrend des Skalierens: weniger als 1% Fehler
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<2000'],
    checks: ['rate>0.99'],
  },
};

function jsonParams(token) {
  const headers = { 'Content-Type': 'application/json', Host: HOST };
  if (token) {
    headers.Authorization = token;
  }
  return { headers: headers };
}

export function setup() {
  const email = `k6-${Date.now()}@example.com`;
  const body = JSON.stringify({
    firstName: 'K6', lastName: 'LoadTest', email: email, password: PASSWORD,
  });

  const register = http.post(`${BASE}/api/users/register`, body, jsonParams());
  if (register.status !== 201) {
    fail(`Registrierung fehlgeschlagen: ${register.status} ${register.body}`);
  }

  const login = http.post(
    `${BASE}/api/users/login`,
    JSON.stringify({ email: email, password: PASSWORD }),
    jsonParams(),
  );
  const token = login.headers['Authorization'];
  if (!token) {
    fail(`Login fehlgeschlagen: ${login.status}`);
  }
  console.log(`Setup ok, Testuser ${email}`);
  return { token: token };
}

export default function (data) {
  const params = jsonParams(data.token);

  const me = http.get(`${BASE}/api/users/me`, params);
  check(me, { 'GET /users/me ist 200': (r) => r.status === 200 });

  const all = http.get(`${BASE}/api/users`, params);
  check(all, { 'GET /users ist 200': (r) => r.status === 200 });

  sleep(0.8);
}
