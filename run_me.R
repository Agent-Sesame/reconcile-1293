run_me <- function() {
  
  source('~/Github/reconcile-1293 roth/year_path.R');
  source('~/Github/reconcile-1293 roth/bkr_roth_lots.R');
  source('~/Github/reconcile-1293 roth/bkr_roth_pos.R');
  source('~/Github/reconcile-1293 roth/cb_roth_trans.R');
  source('~/Github/reconcile-1293 roth/qpf_roth.R');
  source('~/Github/reconcile-1293 roth/qtn_roth.R');
  source('~/Github/reconcile-1293 roth/rec_roth_lots.R');
  source('~/Github/reconcile-1293 roth/rec_roth_pos.R');
  source('~/Github/reconcile-1293 roth/rec_roth_trans.R');
  rec_roth_lots();
  rec_roth_pos();
  rec_roth_trans()
  
}
