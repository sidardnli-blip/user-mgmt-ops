// Aufgabe 6: Last auf die komplette Kette
// Client -> Ingress -> user_mgmt_service -> module_service -> Managed MySQL.
// Zeigt, ob die CPU-/Memory-Limits des module_service richtig dimensioniert sind.
import http from 'k6/http';
import { check, sleep, fail } from 'k6';

const BASE = __ENV.TARGET_URL || 'http://ingress-nginx-controller.ingress-nginx.svc.cluster.local';
const HOST = __ENV.TARGET_HOST || 'localhost';
const PASSWORD = 'k6-load-test-1234';

// Die vier Demo-Module, die der module_service beim Start anlegt
const MODULES = [
  'c02f58f2-3aca-4f1e-8076-bacf6f1999e6',
  '6d5889ee-f4c7-44d7-a887-da92d2a51ac4',
  '674ca4e0-6334-4b12-aa83-d97895049b8a',
  '4b9ff45a-d90f-42b0-8b72-20f0b92b6027',
];

export const options = {
  stages: [
    { duration: '1m', target: 10 },
    { duration: '2m', target: 30 },
    { duration: '2m', target: 30 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
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
  const email = `k6-module-${Date.now()}@example.com`;
  const register = http.post(
    `${BASE}/api/users/register`,
    JSON.stringify({ firstName: 'K6', lastName: 'Module', email: email, password: PASSWORD }),
    jsonParams(),
  );
  if (register.status !== 201) {
    fail(`Registrierung fehlgeschlagen: ${register.status} ${register.body}`);
  }
  const userId = register.json('id');

  const login = http.post(
    `${BASE}/api/users/login`,
    JSON.stringify({ email: email, password: PASSWORD }),
    jsonParams(),
  );
  const token = login.headers['Authorization'];
  if (!token) {
    fail(`Login fehlgeschlagen: ${login.status}`);
  }
  console.log(`Setup ok, Testuser ${email} (${userId})`);
  return { token: token, userId: userId };
}

export default function (data) {
  const params = jsonParams(data.token);
  const moduleId = MODULES[Math.floor(Math.random() * MODULES.length)];

  const assign = http.put(
    `${BASE}/api/users/${data.userId}/modules/${moduleId}`,
    null,
    params,
  );
  check(assign, { 'Modulzuweisung ist 200': (r) => r.status === 200 });

  const list = http.get(`${BASE}/api/users/${data.userId}/modules`, params);
  check(list, { 'GET Module ist 200': (r) => r.status === 200 });

  sleep(0.5);
}
