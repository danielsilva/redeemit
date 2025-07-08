# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    @vite_manifest = load_vite_manifest

    respond_to do |format|
      format.html { render :index }
      format.any { redirect_to root_path }
    end
  end

  private

  def load_vite_manifest
    # Load manifest in all environments if it exists
    return {} unless Rails.env.production? || Rails.env.test? || Rails.env.development?

    manifest_path = Rails.public_path.join('assets', '.vite', 'manifest.json')
    return {} unless File.exist?(manifest_path)

    JSON.parse(File.read(manifest_path))
  rescue JSON::ParserError
    {}
  end

  def js_path(entry_name)
    return '/assets/main.js' unless @vite_manifest.present?

    entry = @vite_manifest[entry_name]
    return '/assets/main.js' unless entry

    "/assets/#{entry['file']}"
  end
  helper_method :js_path

  def css_paths(entry_name)
    return ['/assets/main.css'] unless @vite_manifest.present?

    entry = @vite_manifest[entry_name]
    return ['/assets/main.css'] unless entry&.dig('css')

    entry['css'].map { |css_file| "/assets/#{css_file}" }
  end

  def css_tags(entry_name)
    css_paths(entry_name).map do |css_path|
      "<link rel=\"stylesheet\" href=\"#{css_path}\">"
    end.join("\n    ").html_safe
  end
  helper_method :css_tags
end
