# Only portuguese is supported by now
I18n.available_locales = [:'pt-BR']
I18n.default_locale = :'pt-BR'
I18n.load_path += Dir[File.join(Rails.root, 'config', 'locales', '**', '*.{yml}')]
