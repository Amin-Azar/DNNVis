
echo "<!DOCTYPE html> \
<html> \
<head> \
  <link rel="stylesheet" href="styles.css"> \
</head> \
<body>" > index.html

## write architecture
echo "<div id="col-1">" >> index.html
echo "<p>" >> index.html
input="resnet18.arch"
while IFS= read -r ln
do
  color=''
  [[ -z $(echo $ln | grep "conv\|layer") ]] && color="style='color:green'" || color="style='color:red'"
  #ln1=$(echo $ln | sed 's/    /<blockquote>/g')
  echo "<span $color><pre>$ln</pre></span>" >> index.html
done < "$input"
echo "</p>" >> index.html
echo "</div>" >> index.html

echo "<div id="col-2">" >> index.html

# input images
ext=hotdog
output_html=index_$ext.html
echo "<br><br><a href=\"$output_html\" style='color:red'>Input $ext images (ALL)</a><br><br><br>" >> index.html
echo "<div><a href=\"index.html\">BACK</a></div>"> $output_html

echo "<div><a>Input $ext images</a></div>">> $output_html
for im in ../../../IMAGENET-UNCROPPED-$ext/train/n01531178/n01531178_1*
do
    echo "<a><img title=\"$im\"   src=\"$im\"   width=60 height=60 ></a> ">> $output_html
done


for file in run_all/in_acts/*.npy
do
    bf=$(basename $file)
    fi=$(echo $bf | sed 's/\.npy//g')
    output_html=index_$fi.html
    fi_layer_name=$(echo $fi | sed 's/resnet18_dp-True_wt-0_ep-0_itt-0_layer-//g' | sed 's/_Conv2d/ /g' | sed 's/_in_acts/ (in-Act)/g')
    echo "<a href=\"$output_html\">$fi_layer_name</a><br><br>" >> index.html
    echo $fi
    echo "<div><a href=\"index.html\">BACK</a></div>"> $output_html
    echo "<div><a>$fi</a></div>">> $output_html
    for f in run_all/in_acts/$fi*.png
    do 
        tag=$f #( echo $f | sed 's/.*chann/chann/g')
        echo "<a><img title=\"$tag\"   src=\"$f\"   width=300></a> ">> $output_html
    done
done

echo "</div>" >> index.html
echo "</body> \
</html>" >> index.html
