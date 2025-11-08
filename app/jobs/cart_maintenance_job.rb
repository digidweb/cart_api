# app/jobs/cart_maintenance_job.rb
class CartMaintenanceJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "🛒 [CartMaintenance] Iniciando manutenção de carrinhos..."

    # 1. Marcar carrinhos inativos como abandonados
    mark_stale_carts_as_abandoned

    # 2. Limpar carrinhos abandonados há muito tempo
    clean_old_abandoned_carts

    # 3. Limpar carrinhos completados antigos
    clean_old_completed_carts

    Rails.logger.info "✅ [CartMaintenance] Manutenção concluída!"
  end

  private

  # Marca carrinhos ativos mas inativos há mais de 30 minutos como abandonados
  def mark_stale_carts_as_abandoned
    stale_carts = Cart.active.stale
    count = stale_carts.count

    if count > 0
      stale_carts.find_each do |cart|
        cart.mark_as_abandoned!
        Rails.logger.info "  ⏰ Carrinho ##{cart.id} marcado como abandonado"
      end
      Rails.logger.info "  📊 #{count} carrinho(s) marcado(s) como abandonado(s)"
    else
      Rails.logger.info "  ✓ Nenhum carrinho inativo encontrado"
    end
  end

  # Remove carrinhos abandonados há mais de 7 dias
  def clean_old_abandoned_carts
    old_abandoned = Cart.abandoned.where('abandoned_at < ?', 7.days.ago)
    count = old_abandoned.count

    if count > 0
      old_abandoned.destroy_all
      Rails.logger.info "  🗑️  #{count} carrinho(s) abandonado(s) antigo(s) removido(s)"
    else
      Rails.logger.info "  ✓ Nenhum carrinho abandonado antigo para remover"
    end
  end

  # Remove carrinhos completados há mais de 30 dias
  def clean_old_completed_carts
    old_completed = Cart.completed.where('updated_at < ?', 30.days.ago)
    count = old_completed.count

    if count > 0
      old_completed.destroy_all
      Rails.logger.info "  🗑️  #{count} carrinho(s) completado(s) antigo(s) removido(s)"
    else
      Rails.logger.info "  ✓ Nenhum carrinho completado antigo para remover"
    end
  end
end
