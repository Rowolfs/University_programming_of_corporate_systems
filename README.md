# Практика #6 ЭФБО-09-23 Волков Роман

[debug] [2025-10-28T08:02:58.634Z] <<< [apiv2][body] POST https://firebase.googleapis.com/v1beta1/projects/fir-demo-project/androidApps {"error":{"code":403,"message":"The caller does not have permission","status":"PERMISSION_DENIED"}}
[debug] [2025-10-28T08:02:58.634Z] Request to https://firebase.googleapis.com/v1beta1/projects/fir-demo-project/androidApps had HTTP Error: 403, The caller does not have permission
[debug] [2025-10-28T08:02:58.724Z] FirebaseError: Request to https://firebase.googleapis.com/v1beta1/projects/fir-demo-project/androidApps had HTTP Error: 403, The caller does not have permission
    at responseToError (C:\Users\rovol\AppData\Roaming\npm\node_modules\firebase-tools\lib\responseToError.js:53:12)
    at RetryOperation._fn (C:\Users\rovol\AppData\Roaming\npm\node_modules\firebase-tools\lib\apiv2.js:312:77)
    at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
[error] 
[error] Error: Failed to create Android app for project fir-demo-project. See firebase-debug.log for more info.