
//importScripts("https://www.gstatic.com/firebasejs/10.10.0/firebase-app.js");
//importScripts("https://www.gstatic.com/firebasejs/10.10.0/firebase-messaging.js");
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js');


firebase.initializeApp({
  apiKey: "AIzaSyCI8n08uzrsk_4L7-ipvaa4y7PLJzuj89k",
  authDomain: "eagle-eye-oprator.firebaseapp.com",
  projectId: "eagle-eye-oprator",
  storageBucket: "eagle-eye-oprator.firebasestorage.app",
  messagingSenderId: "1086312563652",
  appId: "1:1086312563652:web:090170d09ceceeb0b15a91",
  measurementId: "G-WTRVEYKMG1"
});


const messaging = firebase.messaging();

//messaging.onBackgroundMessage((payload) => {
//  console.log("Received background message:", payload);
//
//  self.registration.showNotification(payload.notification.title, {
//    body: payload.notification.body,
//    icon: "/favicon.ico"
//  });
//});

// Handle notification click event
//self.addEventListener('notificationclick', function(event) {
//  event.notification.close();
//  event.waitUntil(
//   clients.openWindow("https://eagle-eye-oprator.web.app");
//  );
//});
