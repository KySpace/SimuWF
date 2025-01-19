% mkphasediagramtable

schminfo = loadschminfo(testpath, fn_vary=["freq_shake_rel" "ampl_shake_rel"]);
tmpl = "analysis/tmpl.html";

for frameidx = 1 : 4

imgpathgen = @(i) sprintf("%s\\AnalysisOutput\\Momentum.[idx=%i].[frame=%i].bmp", testpath, i, frameidx);
report = genmultitableimg(schminfo, tmpl, 2, 3, imgpathgen);
xmlwrite(sprintf("%s\\PhaseDiagram.%i.html", testpath, frameidx) , report)

end