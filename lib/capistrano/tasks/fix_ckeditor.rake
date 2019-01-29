namespace :deploy do
  desc "Fix ckeditor nondigest assets"
  task :fix_ckeditor do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ckeditor:fix_nondigest'
        end
      end
    end
  end
end
