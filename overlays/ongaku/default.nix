{inputs, ...}: final: prev: {inherit (inputs.ongaku.packages.${prev.system}) ongaku;}
