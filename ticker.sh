colored_ticker(){
    data=$(curl -sG "https://query2.finance.yahoo.com/v6/finance/quote?symbols=$1" | tail -1)
    current_price=$(echo $data | jq -r '.quoteResponse.result[0].regularMarketPrice')
    price_change=$(echo $data | jq -r '.quoteResponse.result[0].regularMarketChange')
    if (( $(echo "${price_change} > 0.0" | bc) )); then
        color='\[\033[0;32m\]' # green
    elif (( $(echo "${price_change} == 0.0" | bc) )); then
        color='\[\033[0;37m\]' # gray
    else
        color='\[\033[0;31m\]' # red
    fi
    printf "$1=$color%.2f\[\033[1;00m\]" "$current_price"
}

set_bash_prompt(){
    PS1="\u@$(colored_ticker $TICKER):~$ "
}

export TICKER=$1
PROMPT_COMMAND=set_bash_prompt
