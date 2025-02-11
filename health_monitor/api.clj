(ns health-monitor.api
  (:require [compojure.core :refer :all]
            [ring.middleware.json :refer [wrap-json-response wrap-json-body]]
            [health-monitor.iam :as iam]
            [health-monitor.ml :as ml]))

(defroutes app-routes
  (POST "/auth/biometric" {body :body}
    (let [{:keys [user-id biometric-data]} body]
      (if (iam/verify-biometric-data user-id biometric-data)
        {:status 200
         :body {:token (iam/generate-auth-token (get-user user-id))}}
        {:status 401
         :body {:error "Biometric verification failed"}})))

  (POST "/health/data" {body :body}
    (let [anomalies (ml/analyze-health-data body)]
      {:status 200
       :body {:anomalies anomalies}})))

(def app
  (-> app-routes
      wrap-json-body
      wrap-json-response))
