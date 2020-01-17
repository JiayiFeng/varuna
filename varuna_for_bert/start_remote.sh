machines=(p40-gpu-0002 p40-gpu-0003 p40-gpu-0005 p40-gpu-0007 p100-gpu-0001 p100-gpu-0002 p100-gpu-0003 p100-gpu-0004)

if [ $# != 3 ]
then
    echo "need 3 arguments!!"
    exit
fi

nservers=$2
ngpus=$1

# for change signal
echo $3>args

cd ~/t-nisar/Varuna/varuna_for_bert; source activate varuna;

i=1
while [ $i != $nservers ]
do
    echo $i
    mid="launch_bert.py --node_rank $i --nservers $nservers --ngpus_per_server $ngpus"
    ssh "${machines[i]}" "echo sshed; cd ~/t-nisar/Varuna/varuna_for_bert; source ~/anaconda3/bin/activate varuna; echo \$SQUAD_DIR; GLOO_SOCKET_IFNAME=eth0 python $mid $3" > ssh_out_$i  2>ssh_err_$i &
    i=$(($i+1))
done
mid="launch_bert.py --node_rank 0 --nservers $nservers --ngpus_per_server $ngpus"
python $mid $3

