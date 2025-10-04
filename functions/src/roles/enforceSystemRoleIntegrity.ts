import * as functions from 'firebase-functions';

export const enforceSystemRoleIntegrity = functions.firestore
  .document('roles/{roleId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    if (beforeData.isSystem) {
      if (
        beforeData.name !== afterData.name ||
        beforeData.isSystem !== afterData.isSystem
      ) {
        throw new functions.https.HttpsError('permission-denied', 'System roles cannot be modified in this way.');
      }
    }

    return null;
  });
