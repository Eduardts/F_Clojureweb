(ns health-monitor.iam
  (:require [buddy.auth :as auth]
            [buddy.sign.jwt :as jwt]
            [clojure.core.async :as async]))

(defrecord User [id email roles permissions biometric-data])
(defrecord Role [name permissions])

(def permissions-channel (async/chan 1000))

(defn verify-biometric-data [user-id biometric-data]
  (let [stored-data (get-stored-biometric user-id)
        match-score (calculate-biometric-match stored-data biometric-data)]
    (> match-score 0.95)))

(defn generate-auth-token [user]
  (jwt/sign {:user-id (:id user)
             :roles (:roles user)}
            auth-secret-key))

(defn verify-permissions [user resource]
  (async/go
    (let [user-perms (:permissions user)
          required-perms (get-resource-permissions resource)]
      (every? (set user-perms) required-perms))))
