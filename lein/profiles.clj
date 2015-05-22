{:user {:plugins
        [
         ;; see https://github.com/weavejester/cljfmt/issues/12
         ;; [lein-ancient "0.5.5"] ;; leads to clj-rewrite conflig
         [cider/cider-nrepl "0.9.0-SNAPSHOT"]
         ]
        :dependencies [[clj-stacktrace "0.2.8"]]
        :injections [(let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                            'print-cause-trace)
                           new (ns-resolve (doto 'clj-stacktrace.repl require)
                                           'pst)]
                       (alter-var-root orig (constantly (deref new))))]

        }
}
