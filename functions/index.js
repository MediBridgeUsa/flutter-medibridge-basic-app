const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const firestore = admin.firestore();

/**
 * Se ejecuta cuando un nuevo usuario es creado en Firebase Authentication.
 * Asigna custom claims por defecto (`role: 'user'`) y crea un documento
 * espejo en la colección 'users' de Firestore.
 */
exports.onAuthCreate = functions.auth.user().onCreate(async (user) => {
  const claims = { role: 'user', isApproved: false };
  await admin.auth().setCustomUserClaims(user.uid, claims);

  const providerData = user.providerData.map(p => p.providerId);
  const providers = {
      email: providerData.includes('password'),
      google: providerData.includes('google.com'),
      apple: providerData.includes('apple.com'),
  }

  await firestore.doc(`users/${user.uid}`).set({
    email: user.email ?? '',
    displayName: user.displayName ?? '',
    photoURL: user.photoURL ?? '',
    role: 'user', // Rol por defecto, la fuente de verdad son los claims
    isApproved: false, // Requiere aprobación por defecto
    providers: providers,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });

  functions.logger.info(`User ${user.uid} created with default claims and Firestore document.`);
});

/**
 * Función invocable (Callable Function) para que un admin o superadmin
 * asigne un rol y estado de aprobación a un usuario.
 */
exports.setUserRole = functions.https.onCall(async (data, context) => {
  // 1. Validar que el invocador sea admin o superadmin
  const actorRole = context.auth?.token.role;
  if (!(actorRole === 'admin' || actorRole === 'superadmin')) {
    throw new functions.https.HttpsError('permission-denied', 'El actor debe ser admin o superadmin.');
  }

  const { uid, role, isApproved } = data;

  // 2. Validar datos de entrada
  if (!uid || !['user', 'admin', 'superadmin'].includes(role) || typeof isApproved !== 'boolean') {
      throw new functions.https.HttpsError('invalid-argument', 'Datos de entrada no válidos.');
  }

  // 3. Asignar claims y actualizar documento en Firestore
  await admin.auth().setCustomUserClaims(uid, { role, isApproved });
  await firestore.doc(`users/${uid}`).set({ 
    role, 
    isApproved, 
    updatedAt: admin.firestore.FieldValue.serverTimestamp() 
  }, { merge: true });

  // 4. Registrar en el log de auditoría
  await firestore.collection('auditLogs').add({
    actorUid: context.auth?.uid,
    action: 'setUserRole',
    targetUid: uid,
    meta: { role, isApproved },
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  functions.logger.info(`Role for user ${uid} set to '${role}' by ${context.auth?.uid}.`);
  return { ok: true, message: `Rol actualizado para ${uid}` };
});
