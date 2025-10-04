import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const preventRoleDeletionIfAssigned = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  const roleId = data.roleId;
  if (!roleId) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with one argument "roleId".');
  }

  const usersWithRole = await admin.firestore().collection('users').where('roleId', '==', roleId).get();

  if (!usersWithRole.empty) {
    throw new functions.https.HttpsError('failed-precondition', `Role ${roleId} cannot be deleted, as it is still assigned to ${usersWithRole.size} user(s).`);
  }

  return { success: true };
});
