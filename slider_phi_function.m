% execution when moving slider_phi


phi=get(slider_phi,'Value')*pi/180;
[p,b1,b2,b3,c1,c2,c3] = compute_configuration_from_xyphi(p(1),p(2),phi,mode,geometry);
plot_configuration;
set(slider_current,'string',phi*180/pi);