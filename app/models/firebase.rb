require "google/cloud/firestore"

class Firebase
    def self.notification(device_token, title, body)
        project_id = 'matchpet-a1542' # Your project_id

        client  = Fcmpush.new(project_id)
        payload = { # ref. https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
            message: {
                token: device_token,
                notification: {
                    title:,
                    body:
                }
            }
        }

        response = client.push(payload)

        json = response.json
        json[:name]
    end

    def self.get_token(user_id)
        firestore = Google::Cloud::Firestore.new(
            project_id: 'matchpet-a1542',
            credentials: "#{Rails.root}/config/matchpet-a1542-firebase-adminsdk-blos5-6c93b7dcaa.json"
        )
        user = firestore.col('userDeviceToken').doc(user_id).get

        user.data[:deviceToken]
    end
end
