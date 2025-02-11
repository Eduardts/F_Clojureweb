(ns health-monitor.ml
  (:require [keras-clj.core :as keras]
            [clojure.core.async :as async]))

(def health-model (keras/load-model "health_anomaly_detector.h5"))

(defn analyze-health-data [data]
  (async/go
    (let [processed-data (preprocess-health-data data)
          predictions (keras/predict health-model processed-data)]
      (detect-anomalies predictions))))

(defn detect-anomalies [predictions]
  (let [threshold 0.85]
    (->> predictions
         (map-indexed vector)
         (filter #(> (second %) threshold))
         (map first))))
