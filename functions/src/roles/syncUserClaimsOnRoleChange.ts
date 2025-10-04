import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const syncUserClaimsOnRoleChange = functions.firestore
  .document('users/{uid}')
  .onWrite(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    if (!afterData || beforeData?.roleId === afterData.roleId) {
      console.log('No role change detected.');
      return null;
    }

    const uid = context.params.uid;
    const roleId = afterData.roleId;

    const roleDoc = await admin.firestore().collection('roles').doc(roleId).get();

    if (!roleDoc.exists) {
      console.error(`Role ${roleId} not found.`);
      return null;
    }

    const roleData = roleDoc.data()!;
    const claims: { [key: string]: any } = { roleId };

    for (const module in roleData.permissionsByModule) {
      for (const permission in roleData.permissionsByModule[module]) {
        claims[`perm_${module}_${permission}`] = roleData.permissionsByModule[module][permission];
      }
    }

    await admin.auth().setCustomUserClaims(uid, claims);
    return admin.firestore().collection('users').doc(uid).update({ updatedAt: admin.firestore.FieldValue.serverTimestamp() });
  });
