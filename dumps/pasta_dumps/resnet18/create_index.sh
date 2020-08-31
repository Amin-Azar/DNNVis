
function begin_index {
  main_html=$1 #index.html
  echo "<!DOCTYPE html> \
  <html> \
  <head> \
    <link rel="stylesheet" href="styles.css"> \
  </head> \
  <body>" > $main_html
}

function end_index {
  main_html=$1 # index.html
  echo "</body> \
  </html>" >> $main_html
}

function create_arch {
  main_html=$1 # $index.html
  input=$2 #"resnet18.arch"
  col_id=$3
  ## write architecture
  echo "<div id="col-$col_id">" >> $main_html
  echo "<p>" >> $main_html
  
  while IFS= read -r ln
  do
    color=''
    [[ -z $(echo $ln | grep "conv\|layer") ]] && color="style='color:green'" || color="style='color:red'"
    #ln1=$(echo $ln | sed 's/    /<blockquote>/g')
    echo "<span $color><pre>$ln</pre></span>" >> $main_html
  done < "$input"
  echo "</p>" >> $main_html
  echo "</div>" >> $main_html
}

function create_acts {
  main_html=$1 # index.html
  acts=$2 # in_acts
  ext=$3 # bird
  col_id=$4 # 2
  run_fld=run_all
  output_html=index_$ext.html
  width=300

  echo "<div id="col-$col_id">" >> $main_html
  echo "<div><a href=\"$main_html\">BACK</a></div>"> $output_html
  for file in $run_fld/$acts/*.npy
  do
      bf=$(basename $file)
      fi=$(echo $bf | sed 's/\.npy//g')
      output_html=index_$fi.html
      fi_layer_name=$(echo $fi | sed 's/resnet18_dp-True_wt-0_ep-0_itt-0_layer-//g' | sed 's/_Conv2d/ /g' | sed "s/_$acts/ ($acts)/g")
      echo "<a href=\"$output_html\">$fi_layer_name</a><br><br>" >> $main_html
      echo $fi
      echo "<div><a href=\"$main_html\">BACK</a></div>"> $output_html
      echo "<div><a>$fi</a></div>">> $output_html
      for f in $run_fld/$acts/$fi*.png
      do 
          tag=$f #( echo $f | sed 's/.*chann/chann/g')
          echo "<a><img title=\"$tag\"   src=\"$f\"   width=$width></a> ">> $output_html
      done
  done
  echo "</div>" >> $main_html

}
## =================================================================================

# BEGIN
begin_index index.html
# Columns
create_arch index.html resnet18.arch 1
create_acts index.html in_acts bird 2
create_acts index.html out_acts bird 3
# END
end_index index.html
