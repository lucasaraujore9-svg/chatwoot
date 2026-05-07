Rails.application.config.after_initialize do
  if defined?(Sidekiq) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash({
                                        'atende_expire_sessions' => {
                                          'cron' => '*/30 * * * *',
                                          'class' => 'Atende::ExpireSessionsJob',
                                          'queue' => 'scheduled',
                                          'description' => 'Expire stale Atende flow/agent sessions'
                                        },
                                        'atende_check_sla_violations' => {
                                          'cron' => '*/5 * * * *',
                                          'class' => 'Atende::CheckSlaViolationsJob',
                                          'queue' => 'scheduled',
                                          'description' => 'Check and mark SLA breaches'
                                        }
                                      })
  end
end
