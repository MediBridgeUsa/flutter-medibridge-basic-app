import * as admin from 'firebase-admin';

export async function writeAuditLog(actorUid: string, action: string, entity: string, before: any, after: any) {
  return admin.firestore().collection('audit_logs').add({
    actorUid,
    action,
    entity,
    before,
    after,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
}
